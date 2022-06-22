//
//  QueryService.swift
//  FootballNews
//
//  Created by LAP13606 on 08/06/2022.
//

import Foundation

//Class summary
//Support
//Use
//



//MARK: Class custom Operation
fileprivate class QueryServiceOperation: CustomOperation {
    
    
    override func main() {
    
        if isCancelled {
            
            return
            
        }
        
        QueryService.sharedService.startCallApi(self.url, self.method, session: session) {
            
            [weak self]
            result in
            
            switch result {
                
            case .success(let res):
                
                self?.response = res       
               
                
            case .failure(let err):
                
                print(err)
                self?.response = nil
                
            }
            self?.finish()
        }
        

    }
}

//MARK: DELEGATION CLASS - QUERY DATA API

class QueryService: NetworkManager {
    
    
    //Singleton
    static let sharedService = QueryService()
    
    //Constant (Use to config sessoin)
    private let timeoutForRequest = TimeInterval(30)
    private let timeoutForResource = TimeInterval(60)
    
    private let sessionConfig = URLSessionConfiguration.default
    
    var querySession: URLSession?
    
    //Operation queue to manage download
    let operationQueue = OperationQueue()
    
    //Private Init
    override private init() {
        
        //Create session
        sessionConfig.timeoutIntervalForRequest = timeoutForRequest
        sessionConfig.timeoutIntervalForResource = timeoutForResource
        
        self.querySession = URLSession(configuration: sessionConfig,
                                  delegate: nil,
                                  delegateQueue: operationQueue)
        
        //Config Operation Queue
        operationQueue.maxConcurrentOperationCount = 5
        let dispatchQueue = DispatchQueue(label: "queryQueue", qos: .utility, attributes: .concurrent)
        operationQueue.underlyingQueue = dispatchQueue

    }
    

    //MARK: GET METHOD - use this for calling GET method
    // Return: decoded Data (Struct, Class)
    func get<T: Codable> (_ api: APITarget,
                           completion: @escaping ( Result<T,Error> ) -> Void ) {
        
        guard let querySession = querySession else {
            
            return
            
        }
        let customOperation = QueryServiceOperation(url: api.link, method: .GET, session: querySession)
        
        print(api)
        //Completion block, execute after operation main() done
        customOperation.completionBlock = {
            
            [weak customOperation] in
            guard let customOperation = customOperation else {
                return
            }
            
            if customOperation.isCancelled {
                
                completion(.failure(ManagerErrors.OperationCancel))
                
            }
            
            guard let response = customOperation.response else {
                
                completion(.failure(ManagerErrors.BadData))
                return
                
            }
            
           //MARK: -- FUNCTION TO DECODE RESPONSE --
            guard let data = response._data else {
                
                completion(.failure(ManagerErrors.BadData))
                return
                
            }
           
            let decoder = JSONDecoder()
            do {

                let jsonData = try decoder.decode(T.self, from: data)
                completion(.success(jsonData))

            } catch {

                completion(.failure(error))
                print(error.localizedDescription)

            }
            
        }
        
        // Operation Queue execute Operation
        operationQueue.addOperation(customOperation)
        
    }
}



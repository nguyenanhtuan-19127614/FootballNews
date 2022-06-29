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

    var data: Data?
    var apiTarget: APITarget?
    var session: URLSession = URLSession()
    
    private var task : URLSessionDataTask?
    
    init(apiTarget: APITarget, session: URLSession) {
       
        super.init()
        self.apiTarget = apiTarget
        self.session = session

    }
    
    //MARK: Create and run query task
    func runQueryTask(apiTarget: APITarget,
                      session: URLSession,
                      completion: @escaping (Result<Data, Error>) -> Void){
        
        //Create URL Components
        guard let urlComponent = URLComponents(string: apiTarget.link) else {
            
            completion(.failure(ManagerErrors.BadURL))
            return
            
        }
        
        //Create URL
        let url = urlComponent.url!
        
        // Create a request URL
        var request = URLRequest(url: url)
        request.httpMethod = apiTarget.method.rawValue
        request.allHTTPHeaderFields = [
            "api_key": "bm_fresher_2022"
        ]
        
        
        self.task = session.dataTask(with: request) {
            

            (data, response, error) in
                                         
            
        
            guard let response = response else {
                
                completion(.failure(ManagerErrors.BadResponse))
                return
                
            }
            
            //Check Response Code
            if let httpResponse = response as? HTTPURLResponse {
                
                if httpResponse.statusCode == 503 {
                    
                    completion(.failure(ManagerErrors.ServiceUnavailable_503))
                
                }
                
            }
            
            
            guard let data = data else {

                if let error = error {
            
                    completion(.failure(error))
            
                }
                
                return
                
            }
            
            completion(.success(data))
           
        }
        
        self.task?.resume()
       
    }
    
    //MARK: Main function
    
    override func main() {
    
        if isCancelled {
        
            self.data = nil
            return
            
        }
        
        guard let apiTarget = apiTarget else {
            return
        }
        

        runQueryTask(apiTarget: apiTarget, session: session) {
            
            [weak self]
            result in
            
            switch result {
                
            case .success(let data):
                
                self?.data = data
               
                
            case .failure(let err):
                
                print(err)
                self?.data = nil
                
            }
            
            self?.finish()
            
        }
        
    }
    
    //Handling cancel, if operation is cancel, cancel download task
    override func cancel() {
        super.cancel()
        self.task?.cancel()
        self.finish()
    }
    
}

//MARK: DELEGATION CLASS - QUERY DATA API

class QueryService {
    
    
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
    private init() {
        
        //Create session
        sessionConfig.timeoutIntervalForRequest = timeoutForRequest
        sessionConfig.timeoutIntervalForResource = timeoutForResource
        
        self.querySession = URLSession(configuration: sessionConfig,
                                  delegate: nil,
                                  delegateQueue: nil)
        
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
        let customOperation = QueryServiceOperation(apiTarget: api, session: querySession)

        //Name custom operation
        customOperation.name = api.link
        
        //check if operation allready in queue
        for ope in operationQueue.operations {
            
            if customOperation.name == ope.name {
                
                print("Query Operation already added")
                customOperation.cancel()
                ope.waitUntilFinished()
                guard let data = (ope as! QueryServiceOperation).data else {

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
                
                return
                
            }
        }
        
        //Completion block, execute after operation main() done
        customOperation.completionBlock = {
            
            [weak customOperation] in
            guard let customOperation = customOperation else {
                return
            }
            
            if customOperation.isCancelled {
                
                completion(.failure(ManagerErrors.OperationCancel))
                return
                
            }
            
            guard let data = customOperation.data else {
                
                completion(.failure(ManagerErrors.BadData))
                return
                
            }
            
           //MARK: -- FUNCTION TO DECODE RESPONSE --
           
            let decoder = JSONDecoder()
            do {

                let jsonData = try decoder.decode(T.self, from: data)
                completion(.success(jsonData))

            } catch {

                completion(.failure(error))
                print(error.localizedDescription)

            }
            
        }
        
        if customOperation.isCancelled {
            return
        }
        
        // Operation Queue execute Operation
        operationQueue.addOperation(customOperation)
        
    }
}



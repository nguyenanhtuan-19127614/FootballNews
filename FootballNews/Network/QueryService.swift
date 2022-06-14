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
class QueryServiceOperation: Operation {
    
    var response: Response?
    var url: String = ""
    var method: HttpMethod = .GET
   
    var service: QueryService
    
    init(_ manager: QueryService) {
        
        service = manager
        
    }
    
    func setupOperation(url: String, method: HttpMethod) {
        
        self.url = url
        self.method = method
        
    }
    
    override func main() {
    
        if isCancelled {
            
            return
            
        }
        
        let gr = DispatchGroup()
        
        if let session = service.session {
            gr.enter()
            self.service.startCallApi(self.url, self.method, session: session) {
                
                result in
                
                switch result {
                    
                case .success(let res):
                    self.response = res
                    
                case .failure(let err):
                    print(err)
                
                }
                gr.leave()
            }
            gr.wait()
        }
    }
}

//MARK: DELEGATION CLASS - QUERY DATA API

class QueryService: NetworkManagerProtocol {
    
    
    //Singleton
    static let sharedService = QueryService()
    
    //Constant (Use to config sessoin)
    private let timeoutForRequest = TimeInterval(30)
    private let timeoutForResource = TimeInterval(60)
    
    private let sessionConfig = URLSessionConfiguration.default
    
    var session: URLSession?
    
    //Operation queue to manage download
    let operationQueue = OperationQueue()
    
    //Private Init
    private init() {
        
        //Create session
        sessionConfig.timeoutIntervalForRequest = timeoutForRequest
        sessionConfig.timeoutIntervalForResource = timeoutForResource
        
        self.session = URLSession(configuration: sessionConfig,
                                  delegate: nil,
                                  delegateQueue: operationQueue)
        
        //Config Operation Queue
        operationQueue.maxConcurrentOperationCount = 5
        let dispatchQueue = DispatchQueue(label: "queryQueue", qos: .utility, attributes: .concurrent)
        operationQueue.underlyingQueue = dispatchQueue

    }
  
    
    //MARK: Decode Data Function
    
//    func decodeData<T: APITarget, U: Codable> (api: T) -> ResponseModel<U> {
//
//
//    }
    
    //MARK: GET METHOD - use this for calling GET method
    // Return: decoded Data (Struct, Class)
    func get<T: Codable> (_ api: APITarget,
                           completion: @escaping ( Result<T,Error> ) -> Void ) {
        
        let customOperation = QueryServiceOperation(self)
        
        
        customOperation.setupOperation(url: api.link, method: .GET)
        
        //Completion block, execute after operation main() done
        customOperation.completionBlock = {
            
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



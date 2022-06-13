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
    var queryItems: [String: String]?
    
    var service: QueryService
    
    init(_ manager: QueryService) {
        
        service = manager
        
    }
    
    func setupOperation(url: String,
                        method: HttpMethod,
                        queryItems: [String: String]? = nil ) {
        
        self.url = url
        self.method = method
        self.queryItems = queryItems
        
    }
    
    override func main() {
    
        if isCancelled {
            
            return
            
        }
        
        do {
            
            self.response = try self.service.networkManager.callApi(self.url, self.method, self.queryItems)
            
        } catch {
            
            print(error.localizedDescription)
            
        }
    
    }
}

//MARK: DELEGATION CLASS - QUERY DATA API

class QueryService: NetworkManagerProtocol {
    
    //Singleton
    static let sharedService = QueryService()
    private init() {
        
        networkManager.delegate = self
    
        //Config Operation Queue
        operationQueue.maxConcurrentOperationCount = 5
        let dispatchQueue = DispatchQueue(label: "queryQueue", qos: .utility, attributes: .concurrent)
        operationQueue.underlyingQueue = dispatchQueue
    }
    
    //Operation queue to manage download
    let operationQueue = OperationQueue()
    
    //Base delegation class
    let networkManager = NetworkManager()
    
    
    //MARK: GET METHOD - use this for calling GET method
    // Return: decoded Data (Struct, Class)
    func get<T: Codable> (url: String,
                 _ method: HttpMethod = .GET,
                 queryItems: [String: String]? = nil,
                 completion: @escaping ( Result<T,Error> ) -> Void ) {
        
        let customOperation = QueryServiceOperation(self)
        
        customOperation.setupOperation(url: url, method: method, queryItems: queryItems)
        
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

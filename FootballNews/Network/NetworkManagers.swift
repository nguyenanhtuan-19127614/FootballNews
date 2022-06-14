//
//  NetworkManagers.swift
//  FootballNews
//
//  Created by LAP13606 on 13/06/2022.
//

import Foundation

protocol URLTarget {
   
    var baseURL: String {get set}
    var queryItems: [String: String]? {get set}
    var headers: (String, String) {get set}
    var method: HttpMethod {get set}
    
}

class NetworkCaller {
    
    //Singleton
    static let sharedNetwork = NetworkCaller()
    private init() {}
    
    //Variable
    private let timeoutForRequest = TimeInterval(30)
    private let timeoutForResource = TimeInterval(60)
    let operationQueue = OperationQueue()
    
    private let sessionConfig = URLSessionConfiguration.default
    
    private var session: URLSession?
    
    /* Create Query String
    Parameters:
    - queryItems: Dictionary with query value as [key:item]
    Output:
    -> A query string
    */
    func createQueryString(queryItems: [String: String]?) -> String {
        
        var queryString: String = ""
        if let queryItems = queryItems {
            
            for(key, value) in queryItems {
                
                queryString += "\(key)=\(value)&"
                
            }
            
            queryString.removeLast()
            
        }
        
        return queryString
        
    }
    
    func convert(target: URLTarget) throws -> URLSessionDataTask? {
        
        
        //Create URL Components
        guard var urlComponent = URLComponents(string: target.baseURL) else {
            
            throw(ManagerErrors.BadURL)
            
        }
        
        //Add query string (if exist)
        if let queryItems = target.queryItems {
            
            urlComponent.query = createQueryString(queryItems: queryItems)
            
        }
        
        //Create URL
        let url = urlComponent.url!
       
        //create session
       
        sessionConfig.timeoutIntervalForRequest = timeoutForRequest
        sessionConfig.timeoutIntervalForResource = timeoutForResource
        
        self.session = URLSession(configuration: sessionConfig,
                                  delegate: nil,
                                  delegateQueue: operationQueue)
        
        // Create a request URL
        let _headerFields = target.headers
        var request = URLRequest(url: url)
        request.httpMethod = target.method.rawValue
        request.allHTTPHeaderFields = [
            _headerFields.0: _headerFields.1
        ]
        
        
        let dataTask = session?.dataTask(with: request) {
            

            (data, response, error) in
                                         
            
        
            guard let response = response else {
                
                return
                
            }
        
            guard let data = data else {

                if let error = error {
            
                    print(error)
            
                }
                
                return
                
            }
            
        }
        
        guard let dataTask = dataTask else {
            
            return nil
            
        }
        
        return dataTask
    }
}

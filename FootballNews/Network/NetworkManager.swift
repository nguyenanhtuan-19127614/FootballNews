//
//  NetworkManager.swift
//  NetworkManager
//
//  Created by LAP13606 on 06/06/2022.
//

import Foundation

//Class summary
//Support
//Use
//

let _headerFields: (String, String) = ("api_key", "bm_fresher_2022")

//MARK: RESPONSE BODY
struct Response {
    
    var _data: Data?
    var _response: URLResponse?
    var _error: Error?
    
}

//MARK: ERROR
enum ManagerErrors: Error {
    
    case EmptyData
    case BadURL
    case BadResponse
    case BadData
    case NullDelegation
    case NullSession
    case OperationCancel
    
}

/****
HTTP METHOD
 */
enum HttpMethod: String {
    
    case GET
    case POST
    
}

/****
Delegation Protocol
 */
protocol NetworkManagerProtocol: AnyObject {
        
    func startCallApi (_ url: String,
                       _ method: HttpMethod,
                       _ queryItems: [String : String]?,
                       session: URLSession,
                       completion: @escaping (Result<Response, Error>) -> Void)
    
}

extension NetworkManagerProtocol {
    
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
    
    //startCallApi
    func startCallApi (_ url: String,
                       _ method: HttpMethod,
                       _ queryItems: [String : String]?,
                       session: URLSession,
                       completion: @escaping (Result<Response, Error>) -> Void) {
        
        //Create URL Components
        guard var urlComponent = URLComponents(string: url) else {
            
            completion(.failure(ManagerErrors.BadURL))
            return
            
        }
        
        //Add query string (if exist)
        if let queryItems = queryItems {
            
            urlComponent.query = createQueryString(queryItems: queryItems)
            
        }
        
        //Create URL
        let url = urlComponent.url!
        
        // Create a request URL
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = [
            _headerFields.0: _headerFields.1
        ]
        
        let dataTask = session.dataTask(with: request) {
            

            (data, response, error) in
                                         
            
        
            guard let response = response else {
                
                completion(.failure(ManagerErrors.BadResponse))
                return
                
            }
        
            guard let data = data else {

                if let error = error {
            
                    completion(.failure(error))
            
                }
                
                return
                
            }
            
            let responseBody = Response(_data: data, _response: response, _error: error)
            
            completion(.success(responseBody))
            
      
        }
        
        dataTask.resume()
    
    }
    
}

// MARK: MULTICAST CLASS
class NetworkManager: NSObject, URLSessionDelegate {
    
    //Delegation
    weak var delegate: NetworkManagerProtocol?
    
    //Constant (Use to config sessoin)
    private let timeoutForRequest = TimeInterval(30)
    private let timeoutForResource = TimeInterval(60)
    let operationQueue = OperationQueue()
    
    private let sessionConfig = URLSessionConfiguration.default
    
    private var session: URLSession?
   
    
    //INIT
    override init() {
        
        super.init()
        
        //create session
        sessionConfig.timeoutIntervalForRequest = timeoutForRequest
        sessionConfig.timeoutIntervalForResource = timeoutForResource
        
        self.session = URLSession(configuration: sessionConfig,
                                  delegate: self,
                                  delegateQueue: operationQueue)
        
        print("Create Network Manager")
        
    }
    //DELEGATE FUNCTION
    
    /*  Call API
    Parameters:
    - url: url to call API
    - httpMethod: GET, POST,...
    - queryItem: query data
    Output:
    -> Raw Response (data, response, error)
    */
    
    func callApi(_ url: String,
                 _ method: HttpMethod,
                 _ queryItems: [String: String]?) throws -> Response {
        
        var response: Response?
        
        if let delegate = delegate {
            
            guard let session = session else {
                
                throw(ManagerErrors.NullSession)
                
            }
            
            //Use dispatchGroup for waiting execution finish
            let dispatchGroup = DispatchGroup()
            dispatchGroup.enter()
            
            delegate.startCallApi(url, method, queryItems, session: session) {
                
                result in
                switch result {
                    
                case .success(let res):
                    response = res
                    
                case .failure(let err):
                    print(err)
                    
                }
                
                dispatchGroup.leave()
                
            }
            
            dispatchGroup.wait()
            
        } else {
            
            throw(ManagerErrors.NullDelegation)
            
        }
        
        guard let response = response else {
            throw(ManagerErrors.BadData)
        }
        
        return response
        
    }
    
}

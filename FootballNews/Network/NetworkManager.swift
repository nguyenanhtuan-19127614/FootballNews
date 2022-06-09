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
    
    var _data: Any?
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
        
    func startCallApi(_ url: String,
                      _ method: HttpMethod,
                      _ queryItems: [String: String]?,
                      session: URLSession) throws
    
}

extension NetworkManagerProtocol {
    
    func checkResponse(response: Response) throws {
        
        guard response._data != nil else {
            
            throw(ManagerErrors.BadData)
            
        }
        
        guard response._response != nil else {
            
            throw(ManagerErrors.BadResponse)
            
        }
        
    }
    
}
// MARK: MULTICAST CLASS
class NetworkManager: NSObject, URLSessionDelegate {
    
    //Delegation
    weak var delegate: NetworkManagerProtocol?
    
    //Constant
    private let timeoutForRequest = TimeInterval(30)
    private let timeoutForResource = TimeInterval(60)
    private let operationQueue = OperationQueue()
    
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
                 _ queryItems: [String: String]?) throws {
        
        if let delegate = delegate {
            
            guard let session = session else {
                return
            }
            
            try delegate.startCallApi(url, method, queryItems, session: session)
            
            //delegate.finishCallApi()
            
        } else {
            
            throw(ManagerErrors.NullDelegation)
            
        }
       
    }
    
}

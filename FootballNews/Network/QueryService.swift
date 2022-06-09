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
            
            try self.service.networkManager.callApi(self.url, self.method, self.queryItems)
            
        } catch {
            
            print(error.localizedDescription)
            
        }
    
    }
}

//Query Service Notification Name
enum QueryNotiName: String {
    
    case case1 = "NetworkManager.startCallApi.Finish"
    case case2
}

//MARK: DELEGATION CLASS - QUERY DATA API

class QueryService: NetworkManagerProtocol {
    
    //Singleton
    static let sharedService = QueryService()
    private init() {
        
        networkManager.delegate = self
        createObservers()
        
        //Config Operation Queue
        operationQueue.maxConcurrentOperationCount = 5
        let dispatchQueue = DispatchQueue(label: "downloadQueue", qos: .utility, attributes: .concurrent)
        operationQueue.underlyingQueue = dispatchQueue
    }
    
    //Operation queue to manage download
    let operationQueue = OperationQueue()
    
    //Base delegation class
    let networkManager = NetworkManager()
    
    //MARK: GET METHOD
    func get(url: String,
             _ method: HttpMethod = .GET,
             queryItems: [String: String]? = nil) {
        
        let customOperation = QueryServiceOperation(self)
        customOperation.setupOperation(url: url, method: method, queryItems: queryItems)
        operationQueue.addOperation(customOperation)
        
    }
    
    
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
    func startCallApi(_ url: String,
                      _ method: HttpMethod,
                      _ queryItems: [String : String]?,
                      session: URLSession) throws {
        
        //Create URL Components
        guard var urlComponent = URLComponents(string: url) else {
            throw(ManagerErrors.BadURL)
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
        
            if let error = error {
        
                print(error)
        
            }
        
            guard let response = response else {
                
                return
                
            }
        
            guard let data = data else {
                
                return
                
            }
            
            let responseBody = Response(_data: data, _response: response, _error: error)
                       
            let userInfo = ["responseBody": responseBody]
            let notificationName = NSNotification.Name(QueryNotiName.case1.rawValue)
            
            // Post noti
            NotificationCenter.default.post(
                name: notificationName,
                object: nil,
                userInfo: userInfo)
         
        }
        
        dataTask.resume()
    
    }
    
   
   
    //MARK: Create Observers to get noti
    func createObservers() {
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(dosomething(_:)),
            name: NSNotification.Name ("NetworkManager.startCallApi.Finish"),
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(dosomething2(_:)),
            name: NSNotification.Name ("NetworkManager.startCallApi.Finish2"),
            object: nil)
        
    }
    
    //MARK: Observers Function
    
    @objc func dosomething(_ notification: Notification) {
        
        if let data = (notification.userInfo?["responseBody"] as! Response )._data {
            
            print(data as! Data)
//            let jsonObject = try? JSONSerialization.jsonObject(with: data as! Data, options: .allowFragments) as! [String : Any]
//            
//            print(jsonObject)
        }

    }
    
    @objc func dosomething2(_ notification: Notification) {
        
        if let response = (notification.userInfo?["responseBody"] as! Response )._response {
            
            print(response)
            
        }

    }
    
 
}

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


//MARK: HTTP METHOD

enum HttpMethod: String {
    
    case GET
    case POST
    
}

//MARK: API Enum
protocol APITarget {
    
    var link: String { get }
  
}

// Team API
enum TeamAPITarget: APITarget {
    
    case detail(teamID: String)
    case search(name: String)
    case highlights
    
    var link: String {
        
        switch self {
            
        case.detail(teamID: let teamID):
            return "https://bm-fresher.herokuapp.com/api/teams/detail?team_id=" + teamID
            
        case .search(name: let name):
            return "https://bm-fresher.herokuapp.com/api/teams/search?name=" + name
            
        case .highlights:
            return "https://bm-fresher.herokuapp.com/api/teams/highlights"
            
        }
    }
}

//Contents API
enum ContentAPITarget: APITarget {
    
    case detail(contentID: String)
    case home
    case team(teamID: String)
    case comp(id: String)
    case match(id: String)
    case zone(zone: String)
    
    var link: String {
        
        switch self {
        case .detail(let contentID):
            return "https://bm-fresher.herokuapp.com/api/contents/detail?content_id=" + contentID
            
        case .home:
            return "https://bm-fresher.herokuapp.com/api/contents/home"
            
        case .team(let teamID):
            return "https://bm-fresher.herokuapp.com/api/contents/team?id=" + teamID
            
        case .comp(let id):
            return "https://bm-fresher.herokuapp.com/api/contents/comp?id=" + id
            
        case .match(let id):
            return "https://bm-fresher.herokuapp.com/api/contents/match?id=" + id
            
        case .zone(let zone):
            return "https://bm-fresher.herokuapp.com/api/contents/team?zone=" + zone
            
        }
    }
}

//Match API
enum MatchAPITarget: APITarget {
    
    case detail(matchID: String)
    case matchByDate(compID: String, date: String)
    
    var link: String {
        
        switch self {
            
        case .detail(let matchID):
            return "https://bm-fresher.herokuapp.com/api/matches/detail?match_id=" + matchID
            
        case .matchByDate(let compID, let date):
            return "https://bm-fresher.herokuapp.com/api/matches/by-date?competition_id=\(compID)&date=\(date)"
            
        }
    }
}

//Competition API
enum CompetitionAPITarget: APITarget {
    
    case standing(id: String)
    case hot
    
    var link: String {
        
        switch self {
        case .standing(let id):
            return "https://bm-fresher.herokuapp.com/api/competitions/standings?id=" + id
            
        case .hot:
            return "https://bm-fresher.herokuapp.com/api/competitions/hot"
            
        }
    }
}

//MARK: ParentClass

class NetworkManager  {
    
   
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
                       session: URLSession,
                       completion: @escaping (Result<Response, Error>) -> Void) {
        
        //Create URL Components
        guard let urlComponent = URLComponents(string: url) else {
            
            completion(.failure(ManagerErrors.BadURL))
            return
            
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

class CustomOperation: Operation {
    
    var response: Response?
    var url: String = ""
    var method: HttpMethod = .GET
    var session: URLSession
    private let lockQueue = DispatchQueue(label:"LockQueue", attributes: .concurrent)
    
    init(url: String) {
        
        self.url = url
        self.session = URLSession()
    }
    
    init(url: String,method: HttpMethod = .GET, session: URLSession) {
        
        self.url = url
        self.session = session
        self.method = method
    }
    
    deinit {
        print("♻️ Deallocating Download Operation from memory")
        
    }

    override var isAsynchronous: Bool {
        return true
    }
    
    //avoid get-only isExecuting
    public var _isExecuting: Bool = false
    override private(set) var isExecuting: Bool {
        
        get {
            return lockQueue.sync { () -> Bool in
                return _isExecuting
            }
        }
        
        set {
            willChangeValue(forKey: "isExecuting")
            lockQueue.sync(flags: [.barrier]) {
                _isExecuting = newValue
            }
            didChangeValue(forKey: "isExecuting")
        }
        
    }
    
    public var _isFinished: Bool = false
    override private(set) var isFinished: Bool {
        
        get {
            
            return lockQueue.sync { () -> Bool in
                return _isFinished
            }
            
        }
        
        set {
            
            willChangeValue(forKey: "isFinished")
            lockQueue.sync(flags: [.barrier]) {
                _isFinished = newValue
            }
            didChangeValue(forKey: "isFinished")
            
        }
    }

    override func start() {
        
        //print("Starting Operation")
        guard !isCancelled else { return }
        
        isFinished = false
        isExecuting = true
        main()
        
    }
    
    func finish() {
        
        isExecuting = false
        isFinished = true
        
    }
    
    
}



//URLRequest - protocol
//baseURL, queryItems, headers, method (POST, GET)
//
//Converter -> (URLTarget) convert -> URLSessionDataTask
//OperationQueue
//
//NetworkCaller -> (URLTarget) -> Converter -> URLSessionDataTask => call api via URLSession
//
//
//
//enum TeamAPITarget: URLTarget {
//    case detail(id: String)
//    case highlight(id: String)
//}
//
//NetworkCaller.shared.call(TeamAPITarget.detail(id: "1")) { (response: )
//    
//}

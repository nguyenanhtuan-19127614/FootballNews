//
//  CustomOperation.swift
//  FootballNews
//
//  Created by LAP13606 on 25/06/2022.
//

import Foundation

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
        
        if url.starts(with: "http://10") || url.isEmpty {
            print("URL: \(url)")
           
        }
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

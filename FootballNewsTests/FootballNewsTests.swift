//
//  FootballNewsTests.swift
//  FootballNewsTests
//
//  Created by LAP13606 on 06/06/2022.
//

import XCTest
@testable import FootballNews

class FootballNewsTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testNetwork() {
        
        
        
        QueryService.sharedService.get(ContentAPITarget.home) {(result: Result<ResponseModel<ContentModel>, Error>) in
            switch result {
                
            case .success(let res):
               print(res)
       
            case .failure(let err):
                print(err)
                
            }
            
        }
        
        RunLoop.main.run()
        
    }
    
    func testDownloat() {
        
        let _: String = "https://picsum.photos/500/300?random=3"
        let link1 = "https://i.picsum.photos/id/817/500/300.jpg?hmac=YepWK_ujczi0SlqEvc2ZsSgaDvQrHOvMuSEFXYtOIsY"
        let link2 = "https://i.picsum.photos/id/248/500/300.jpg?hmac=-nNcVN6EFbe_pRMbHedsknzyODQbQI8jCaLiGGJLP60"
        let link3 = "https://i.picsum.photos/id/865/500/300.jpg?hmac=Rb8FuZL0U3MTnQZzXtnaHw7CPXPmN7HGAKcBLrMR3uE"
        let links = [link1, link2 , link3, link1, link2]

        let gr = DispatchGroup()
        
        for i in links {
            gr.enter()
            ImageDownloader.sharedService.download(url: i) {

                result in

                switch result {

                case .success(let res):
                    print(res)

                case .failure(let err):
                    print(err)

                }
                gr.leave()
            }
            gr.wait()
        }
        
        
       
        RunLoop.main.run()
        
    }
    
    func testThing() {
        
        print(OperationQueue.defaultMaxConcurrentOperationCount)
        
    }
}

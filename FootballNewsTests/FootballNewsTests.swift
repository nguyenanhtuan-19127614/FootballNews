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
        
   
        let link1: String = "https://bm-fresher.herokuapp.com/api/teams/highlights"
        let link2: String = "https://bm-fresher.herokuapp.com/api/teams/detail?team_id=20"
        let link3: String = "https://bm-fresher.herokuapp.com/api/contents/detail?content_id=42611430"
        let link4: String = "https://bm-fresher.herokuapp.com/api/contents/team?zone=sct_20"
        let link5: String = "https://bm-fresher.herokuapp.com/api/matches/by-date?competition_id=0&date=20220211"
        let link6: String = "https://bm-fresher.herokuapp.com/api/competitions/standings?id=11"
        let link7: String = "https://bm-fresher.herokuapp.com/api/competitions/hot"
        let link8: String = "https://bm-fresher.herokuapp.com/api/contents/home"
        let link9: String = "https://bm-fresher.herokuapp.com/api/teams/search?name=manchester"
        let link10: String = "https://bm-fresher.herokuapp.com/api/contents/match?id=10335"
        
        QueryService.sharedService.get(url: link1)
        QueryService.sharedService.get(url: link2)
        QueryService.sharedService.get(url: link3)
        QueryService.sharedService.get(url: link4)
        QueryService.sharedService.get(url: link5)
        QueryService.sharedService.get(url: link6)
        QueryService.sharedService.get(url: link7)
        QueryService.sharedService.get(url: link8)
        QueryService.sharedService.get(url: link9)
        QueryService.sharedService.get(url: link10)
        
//        let randomLink: String = "https://picsum.photos/500/300?random=1"
//        
//        ImageDownloader.sharedService.run(url: randomLink)
//        ImageDownloader.sharedService.run(url: randomLink)
//        ImageDownloader.sharedService.run(url: randomLink)
//        ImageDownloader.sharedService.run(url: randomLink)
//        ImageDownloader.sharedService.run(url: randomLink)
//        ImageDownloader.sharedService.run(url: randomLink)
//        ImageDownloader.sharedService.run(url: randomLink)
//        ImageDownloader.sharedService.run(url: randomLink)
        
        RunLoop.main.run()
        
    }
    
    func testDownloat() {
        
        let randomLink: String = "https://picsum.photos/500/300?random=3"
        
        for _ in 0..<10 {
            
            ImageDownloader.sharedService.download(url: randomLink)
                
        }
        
        RunLoop.main.run()
        
    }
    
    func testThing() {
        
        print(OperationQueue.defaultMaxConcurrentOperationCount)
        
    }
}

//
//  APITarget.swift
//  FootballNews
//
//  Created by LAP13606 on 25/06/2022.
//

import Foundation

//MARK: ERROR
enum AppErrors: Error {
    
    //Data Error Case
    case EmptyData
    case BadURL
    case BadResponse
    case BadData

    //Response Error Case
    case ServiceUnavailable_503
    
    //Multithread Case
    case NullDelegation
    case NullSession
    case OperationCancel
    case DuplicateOperation
    
    //Task Error
    case TaskCancel
    
    //String
    case CannotConvertHTML
    
}

//MARK: HTTP METHOD

enum HttpMethod: String {
    
    case GET
    case POST
    
}

//MARK: API Enum
protocol APITarget {
    
    var link: String { get }
    var method: HttpMethod { get }
}

// Team API
enum TeamAPITarget: APITarget {
    
    case detail(teamID: String)
    case search(name: String, start: Int, size: Int)
    case highlights(start: Int, size: Int)
    
    var link: String {
        
        switch self {
            
        case.detail(teamID: let teamID):
            return "https://bm-fresher.herokuapp.com/api/teams/detail?team_id=" + teamID
            
        case .search(let name, let start, let size):
            return "https://bm-fresher.herokuapp.com/api/teams/search?name=\(name)&start=\(start)&size=\(size)"
            
        case .highlights(let start, let size):
            return "https://bm-fresher.herokuapp.com/api/teams/highlights?start=\(start)&size=\(size)"
            
        }
    }
    
    var method: HttpMethod {
        
        return HttpMethod.GET
        
    }
    
}

//Contents API
enum ContentAPITarget: APITarget {
    
    case detail(contentID: String)
    case home(start: Int, size: Int)
    case team(teamID: String, start: Int, size: Int)
    case comp(id: String, start: Int, size: Int)
    case match(id: String, start: Int, size: Int)
    case zone(zone: String, start: Int, size: Int)
    
    var link: String {
        
        switch self {
        case .detail(let contentID):
            return "https://bm-fresher.herokuapp.com/api/contents/detail?content_id=" + contentID
            
        case .home(let start, let size):
            //return "hihi"
            return "https://bm-fresher.herokuapp.com/api/contents/home?start=\(start)&size=\(size)"
            
        case .team(let teamID, let start, let size):
            return "https://bm-fresher.herokuapp.com/api/contents/team?id=\(teamID)&start=\(start)&size=\(size)"
            
        case .comp(let id, let start, let size):
            return "https://bm-fresher.herokuapp.com/api/contents/comp?id=\(id)&start=\(start)&size=\(size)"
            
        case .match(let id, let start, let size):
            return "https://bm-fresher.herokuapp.com/api/contents/match?id=\(id)&start=\(start)&size=\(size)"
            
        case .zone(let zone,let start, let size):
            return "https://bm-fresher.herokuapp.com/api/contents/team?zone=\(zone)&start=\(start)&size=\(size)"
            
        }
    }
    
    var method: HttpMethod {
        
        return HttpMethod.GET
        
    }
    
}

//Match API
enum MatchAPITarget: APITarget {
    
    case detail(matchID: String)
    case matchByDate(compID: String, date: String, start: Int, size: Int)
    
    var link: String {
        
        switch self {
            
        case .detail(let matchID):
            return "https://bm-fresher.herokuapp.com/api/matches/detail?match_id=" + matchID
            
        case .matchByDate(let compID, let date, let start, let size):
            return "https://bm-fresher.herokuapp.com/api/matches/by-date?competition_id=\(compID)&date=\(date)&start=\(start)&size=\(size)"
            
        }
    }
    
    var method: HttpMethod {
        
        return HttpMethod.GET
        
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
    
    var method: HttpMethod {
        
        return HttpMethod.GET
        
    }
    
}

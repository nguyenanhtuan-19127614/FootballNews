/* MARK: - API that use this struct:
 
 + GET Match - Detail
 + GET Match - Matches By Date

*/
import Foundation

// MARK: - DataClass [Match]
struct MatchData: Codable {
    
    let soccerMatch: [SoccerMatch]

    enum CodingKeys: String, CodingKey {
            
        case soccerMatch = "soccer_match"
        
    }
    
    init(from decoder: Decoder) throws {

        let values = try decoder.container(keyedBy: CodingKeys.self)

        do {

            soccerMatch = try values.decode([SoccerMatch].self, forKey: .soccerMatch)

        } catch {

            let singleMatch = try values.decode(SoccerMatch.self, forKey: .soccerMatch)
            soccerMatch = [singleMatch]

        }

    }
    
}


// MARK: - SoccerMatch
struct SoccerMatch: Codable {
    
    let lineups: [Lineup]?
    let goals: [Goals]?
    let substs: [Substs]?
    
    let matchID: Int
    let startTime: String
    let groupID: Int
    let groupName: String
    
    let matchStatus: Int
    let time: String
    let round: String
    
    let competition: Competition
    
    let homeScored: Int
    let homeScoredNote: String
    
    let awayScored: Int
    let awayScoredNote: String
    
    let homeTeam: SoccerTeam //Struct from TeamStructure
    let awayTeam: SoccerTeam
    let zone: String

    enum CodingKeys: String, CodingKey {
        
        case lineups
        case goals
        case substs
//        case stats
//        case penaltyShootouts = "penalty_shootouts"
        
        case matchID = "match_id"
        case startTime = "start_time"
        case groupID = "group_id"
        case groupName = "group_name"
        case matchStatus = "match_status"
        case time
        case round
        case competition
        case homeScored = "home_scored"
        case homeScoredNote = "home_scored_note"
        case awayScored = "away_scored"
        case awayScoredNote = "away_scored_note"
        case homeTeam = "home_team"
        case awayTeam = "away_team"
        case zone
    }
}
//Enum type of Team
enum TeamType: String, Codable {
    
    case away = "away"
    case home = "home"
    
}
// MARK: - Lineups
struct Lineup: Codable {
    
    let team: TeamType
    let playerID: Int
    let playerName: String
    let playerNumber: Int
    let isSubstituted: Bool
    let incidents: [Incidents]
    
    enum CodingKeys: String, CodingKey {
        
        case team
        case playerID = "player_id"
        case playerName = "player_name"
        case playerNumber = "player_number"
        case isSubstituted = "is_substituted"
        case incidents
        
    }
}

// MARK: - Incidents

struct Incidents: Codable {
    
    let type: String
    let minute: String
    
    enum CodingKeys: String, CodingKey {
        
        case type
        case minute
        
    }
}

// MARK: - Goals

struct Goals: Codable {
    
    let team: TeamType
    let playerID: Int
    let playerName: String
    let minute: String
    let isPenalty: Bool
    let isOwn: Bool
    let assistID: Int
    let assistName: String?
    let instantScore: String
    
    enum CodingKeys: String, CodingKey {
        
        case team
        case playerID = "player_id"
        case playerName = "player_name"
        case minute
        case isPenalty = "is_penalty_goal"
        case isOwn = "is_own_goal"
        case assistID = "assistant_id"
        case assistName = "assistant_name"
        case instantScore = "instant_score"
        
    }
}

// MARK: - Substs

struct Substs: Codable {
    
    let team: TeamType
    let playerID: Int
    let playerName: String
    let playerNumber: Int
    let isSubstituted: Bool
    let subForID: Int
    let subForName: String?
    let subMinute: String?
    let incidents: [Incidents]
    
    enum CodingKeys: String, CodingKey {
        
        case team
        case playerID = "player_id"
        case playerName = "player_name"
        case playerNumber = "player_number"
        case isSubstituted = "is_substituted"
        case subForID = "subst_for_id"
        case subForName = "subst_for_name"
        case subMinute = "subst_minute"
        case incidents
        
    }
}

/* MARK: - API that use this struct:
 
 + GET Competitions - Hot ( use CompetitionData struct)
 + GET Competitions - Standings ( use StandingData struct)

*/


import Foundation

// MARK: - DataClass [Competition]
struct CompetitionModel: Codable {
    
    let soccerCompetitions: [Competition]

    enum CodingKeys: String, CodingKey {
        
        case soccerCompetitions = "soccer_competitions"
        
    }
    
}

// MARK: - Competition
struct Competition: Codable {
    
    let competitionID: Int
    let competitionName: String
    let competitionLogo: String
    let countryID: Int
    let countryName: String?
    let zone: String
    
    enum CodingKeys: String, CodingKey {
        
        case competitionID = "competition_id"
        case competitionName = "competition_name"
        case competitionLogo = "competition_logo"
        case countryID = "country_id"
        case countryName = "country_name"
        case zone
        
    }
    
}

// MARK: - DataClass [Soccer Standing]
struct CompetitionStandingModel: Codable {
    
    let soccerStandings: [CompetitionStanding]

    enum CodingKeys: String, CodingKey {
            
        case soccerStandings = "soccer_standings"
        
    }
    
}


// MARK: - SoccerStanding
struct CompetitionStanding: Codable {
    let teamID: Int
    let teamName: String
    let groupID: Int
    let groupName: String?
    let zone: String
    let total: Stats
    let home: Stats
    let away: Stats

    enum CodingKeys: String, CodingKey {
        case teamID = "team_id"
        case teamName = "team_name"
        case groupID = "group_id"
        case groupName = "group_name"
        case zone
        case total
        case home
        case away
    }
}

// MARK: - Stats
struct Stats: Codable {
    
    let played, wins, draws, loses, difference, points: Int

}

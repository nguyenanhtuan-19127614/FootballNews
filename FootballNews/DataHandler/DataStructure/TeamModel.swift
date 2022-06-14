/* MARK: - API that use this struct:
 
 + GET Team - Search ( search soccer team by prefix)
 + GET Team - Highlight Teams
 + GET Team - Detail

*/


import Foundation

// MARK: - DataClass [Team]
struct TeamModel: Codable {
    
    var soccerTeams: [SoccerTeam]
    
    enum CodingKeys: String, CodingKey {
        
        case soccerTeams = "soccer_teams"
        case soccerTeam = "soccer_team"
        
    }
    
    func encode(to encoder: Encoder) throws {}
    
    init(from decoder: Decoder) throws {

        let values = try decoder.container(keyedBy: CodingKeys.self)

        do {

            soccerTeams = try values.decode([SoccerTeam].self, forKey: .soccerTeams)

        } catch {

            let singleTeam = try values.decode(SoccerTeam.self, forKey: .soccerTeam)
            soccerTeams = [singleTeam]
            
        }

    }
}

// MARK: - SoccerTeam
struct SoccerTeam: Codable {
    
    let profile: [Profile]
    let teamID: Int
    let teamName: String
    let teamLogo: String
    let zone: String

    enum CodingKeys: String, CodingKey {
        
        case profile
        case teamID = "team_id"
        case teamName = "team_name"
        case teamLogo = "team_logo"
        case zone
        
    }
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        teamID = try values.decode(Int.self, forKey: .teamID)
        teamName = try values.decode(String.self, forKey: .teamName)
        teamLogo = try values.decode(String.self, forKey: .teamLogo)
        zone = try values.decode(String.self, forKey: .zone)
        
        do {
            
            profile = try values.decode([Profile].self, forKey: .profile)
            
        } catch {
            
            profile = []
            
        }
        
    }
    
}

// MARK: - Profile
struct Profile: Codable {
    
    let name: String
    let value: String
    
}

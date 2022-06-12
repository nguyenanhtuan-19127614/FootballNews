//
//  SoccerTeam.swift
//  FootballNews
//
//  Created by LAP13606 on 12/06/2022.
//

import Foundation

// MARK: - DataClass
struct SoccerTeamData: Codable {
    let soccerTeams: [SoccerTeam]
    
    enum CodingKeys: String, CodingKey {
        case soccerTeams = "soccer_teams"
    }
}

// MARK: - SoccerTeam
struct SoccerTeam: Codable {
    let teamID: Int
    let teamName: String
    let teamLogo: String
    let zone: String

    enum CodingKeys: String, CodingKey {
        case teamID = "team_id"
        case teamName = "team_name"
        case teamLogo = "team_logo"
        case zone
    }
}


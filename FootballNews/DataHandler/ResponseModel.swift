
import Foundation

// MARK: - QueryTeam
struct ResponseModel<T: Codable>: Codable {
    
    let data: T
    let errorCode: Int
    let errorMessage: String
        
    enum CodingKeys: String, CodingKey {
        
        case data
        case errorCode = "error_code"
        case errorMessage = "error_message"
        
    }
    
}


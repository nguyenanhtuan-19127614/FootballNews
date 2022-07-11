/* MARK: - API that use this struct:
 
 + GET Contents - Home
 + GET Contents - Team
 + GET Contents - Comp
 + GET Contents - Match
 + GET Contents - Zone
 
*/

import Foundation

// MARK: - DataClass [Contents]
struct ContentModel: Codable {
    
    let contents: [Content]?
    let content: Content?
    let boxes: [Box]?
    let related: Related?
    
    enum CodingKeys: String, CodingKey {
        
        case contents
        case content
        case boxes
        case related
    }
}

// MARK: - Contents ===========================
struct Content: Codable {
    
    let contentID: Int
    let title: String
    let description: String
    let date: Int
    let url: String
    
    let source: String
    let publisherIcon: String
    let publisherLogo: String
    
    let categoryID: Int
    let categoryZone: String
    let categoryName: String

    let avatar: String
    let images: [ImageContents]
    let body: [Body]?
    let tags: [Tag]?
    
    let attributes: Int
    let commentCount: Int
    
    enum CodingKeys: String, CodingKey {
        
        case contentID = "content_id"
        case title
        case description
        case date
        case url
        case source = "source_name"
        case publisherIcon = "publisher_icon"
        case publisherLogo = "publisher_logo"
        case categoryID = "category_id"
        case categoryZone = "category_zone"
        case categoryName = "category_name"
        case avatar = "avatar_url"
        case images
        case body
        case tags
        case attributes
        case commentCount = "comment_count"
    }
}

// MARK: - ImagesContents
struct ImageContents: Codable {
    
    let url: String
    let width: Int
    let height: Int
    enum CodingKeys: String, CodingKey {
        
        case url
        case width
        case height
        
    }
    
}

// MARK: - Tags
struct Tag: Codable {
    
    let name: String
    let segmentID: Int
    let type: Int
    let scheme: String
    
    enum CodingKeys: String, CodingKey {
        
        case name
        case segmentID = "segment_id"
        case type
        case scheme
        
    }
}

// MARK: - Body
struct Body: Codable {
    let type: String
    let content: String
    let originURL: String?
    let width, height: Int?
    let duration, subtype: String?

    enum CodingKeys: String, CodingKey {
        
        case type
        case content
        case originURL = "originUrl"
        case width
        case height
        case duration
        case subtype
        
    }
}

// MARK: - Related
struct Related: Codable {
    let title: String
    let contents: [Content]
}


//MARK: - Box ===========================
struct Box: Codable {
    
    let position: Int
    let sectionBoxID: Int
    let title: String
    let boxDescription: String?
    let displayType: Int
    //let segmentIDS
    let objectType: Int
    let soccerMatches: [SoccerMatch]? //Struct from MatchStructure
    let soccerCompetitions: [Competition]? // Struct from CompetitionsStructure
    //let zone
    let maxShow: Int?
    let positions: [Int]?
    //let videos

    enum CodingKeys: String, CodingKey {
        case position
        case sectionBoxID = "section_box_id"
        case title
        case boxDescription = "description"
        case displayType = "display_type"
        //case segmentIDS = "segment_ids"
        case objectType = "object_type"
        case soccerMatches = "soccer_matches"
        case soccerCompetitions = "soccer_competitions"
        //case zone
        case maxShow = "max_show"
        case positions
        //case videos
    }
    
}

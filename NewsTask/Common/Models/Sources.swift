//
//  Sources.swift
//  NewsTask
//
//  Created by Prabaljit Walia on 18/11/22.
//

// use optionals whereever possible - 
struct Sources: Codable {
    let sources: [Source]
}

struct Source: Codable {
    let id: String?
    let name: String?
    let description: String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
    }
}

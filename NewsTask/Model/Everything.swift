//
//  Everything.swift
//  NewsTask
//
//  Created by Prabaljit Walia on 15/11/22.
//

import Foundation
struct Everything:Codable {
    let articles:[Article]?
    
    init(articles: [Article]?) {
        self.articles = articles
    }
}
struct Article:Codable{
    let author:String?
    let description:String?
    let title:String
    let url:String?
    let urlToImage:String?
    let source:Source?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.author = try container.decodeIfPresent(String.self, forKey: .author)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.title = try container.decode(String.self, forKey: .title)
        self.url = try container.decodeIfPresent(String.self, forKey: .url)
        self.urlToImage = try container.decodeIfPresent(String.self, forKey: .urlToImage)
        self.source = try container.decodeIfPresent(Source.self, forKey: .source)
    }
}

struct Source:Codable{
    let id:String?
    let name:String?
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
    }
}

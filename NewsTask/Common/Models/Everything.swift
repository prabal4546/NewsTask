//
//  Everything.swift
//  NewsTask
//
//  Created by Prabaljit Walia on 15/11/22.
//

// space after colon and every scope of function/class/extension
// if not using encoding - use only Decodable protocol
// if part of grocerySDK - Use 'G' as prefix when in GrocerySDK and 'B' when defining in Blinkit
// define models preferably as nested - if it's scope is not global
// access specifier - public/open
// use class when u think - it can be subclassed in future

struct Everything: Codable {
    let articles: [Article]?
    
    init(articles: [Article]?) {
        self.articles = articles
    }
}

struct Article: Codable {
    let author, description: String?
    let title: String
    let url: String?
    let urlToImage: String?
    let source: Source?
    
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


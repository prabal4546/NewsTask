//
//  Everything.swift
//  NewsTask
//
//  Created by Prabaljit Walia on 15/11/22.
//

import Foundation
struct Everything:Codable {
    let articles:[Article]?
}
struct Article:Codable{
    let author:String?
    let description:String?
    let title:String
    let url:String?
    let urlToImage:String?
    let source:Source?
}

struct Source:Codable{
    let id:String?
    let name:String?
}

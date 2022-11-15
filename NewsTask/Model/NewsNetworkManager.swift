//
//  NewsNetworkManager.swift
//  NewsTask
//
//  Created by Prabaljit Walia on 15/11/22.
//

import Foundation
struct NewsNetworkManager{
    let newsURL =  "https://newsapi.org/v2/everything?q=bitcoin&apiKey=\(Constants.apiKey)"
    
    func fetchNews(url:String){
        let url = URL(string: url)
        let session = URLSession(configuration: .default)
        
    }
}

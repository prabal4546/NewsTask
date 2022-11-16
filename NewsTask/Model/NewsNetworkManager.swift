//
//  NewsNetworkManager.swift
//  NewsTask
//
//  Created by Prabaljit Walia on 15/11/22.
//

import Foundation
struct NewsNetworkManager{
    // what's @escaping
    func fetchNews(url:String, completed: @escaping ([Article]) -> Void){
        guard let url = URL(string: url) else{return}
        let request = URLRequest(url: url)
        // difference b/w response & error
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let safeData = data{
                guard let decodedData = try? JSONDecoder().decode(Everything.self, from: safeData) else{
                    return
                }
                completed(decodedData.articles!)
            }else{
                print(error)
            }
        }
            task.resume()
    }
}

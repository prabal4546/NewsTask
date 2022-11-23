//
//  NewsNetworkManager.swift
//  NewsTask
//
//  Created by Prabaljit Walia on 15/11/22.
//

import Foundation

class NewsNetworkManager {
     var isPaginating = false
    
     func fetch(pagination: Bool = false, url: String, completed: @escaping ([Article]) -> Void) {
        if pagination {
            isPaginating = true
        }
        guard let url = URL(string: url) else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let safeData = data {
                guard let decodedData = try? JSONDecoder().decode(Everything.self, from: safeData) else { return }
                guard let fetchedArticles = decodedData.articles else { return }
                completed(fetchedArticles)
                if pagination {
                    self.isPaginating = false
                }
            } else {
                print(error)
            }
        }
            task.resume()
    }
    
    func fetchSources(url:String, completed: @escaping ([Source]) -> Void) {
        guard let url = URL(string: url) else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let safeData = data{
                guard let decodedData = try? JSONDecoder().decode(Sources.self, from: safeData) else {
                    return
                }
                completed(decodedData.sources)
            } else {
                print(error)
            }
        }
            task.resume()
    }
}

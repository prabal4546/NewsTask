//
//  NewsNetworkManager.swift
//  NewsTask
//
//  Created by Prabaljit Walia on 15/11/22.
//

import Foundation

class NewsNetworkManager {
     var isFetching = false // ✅name incorrect
    
     func fetch(pagination: Bool = false, url: String, completed: @escaping ([Article]) -> Void) {
        if pagination {
            isFetching = true
        }
        guard let url = URL(string: url) else { return }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let safeData = data {
                guard let decodedData = try? JSONDecoder().decode(Everything.self, from: safeData), let fetchedArticles = decodedData.articles else { return }
                DispatchQueue.main.async {
                    completed(fetchedArticles)
                }
                if pagination {
                    self.isFetching = false
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

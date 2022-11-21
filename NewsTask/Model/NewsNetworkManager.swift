//
//  NewsNetworkManager.swift
//  NewsTask
//
//  Created by Prabaljit Walia on 15/11/22.
//

import Foundation

// TODO - Move to VM

struct NewsNetworkManager{
    // what's @escaping
    func fetch(url:String, completed: @escaping ([Article]) -> Void, pagination:Bool = false){
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
    func fetchSources(url:String, completed: @escaping ([Source]) -> Void){
        guard let url = URL(string: url) else{return}
        let request = URLRequest(url: url)
        // difference b/w response & error
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let safeData = data{
                guard let decodedData = try? JSONDecoder().decode(Sources.self, from: safeData) else{
                    return
                }
                completed(decodedData.sources)
            }else{
                print(error)
            }
        }
            task.resume()
    }
}

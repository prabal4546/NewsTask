//
//  ResultsTable.swift
//  NewsTask
//
//  Created by Prabaljit Walia on 15/11/22.
//

import UIKit
import SafariServices

class ResultsTableVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var keyword:String
    var networkManager = NewsNetworkManager()
    var articles:[Article] = [Article]()
    init(keyword: String) {
        
        self.keyword = keyword
        super.init(nibName: nil, bundle: nil)
    }
    // why?
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    let tableView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        
        // FIX ME: -
        networkManager.fetch(url: "\(Constants.baseAPI)/everything?q=\(keyword)&apiKey=\(Constants.apiKey)") { data in
            self.articles = data
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        networkManager.fetch(url: "\(Constants.baseAPI)/top-headlines?country=de&category=\(keyword)&apiKey=\(Constants.apiKey)") { data in
            self.articles = data
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func setupView(){
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
    }

    // TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as? CustomTableViewCell else{return UITableViewCell()}

        let selectedArticle = articles[indexPath.row]
        guard let url = URL(string:selectedArticle.urlToImage ?? "https://ibb.co/7CWHTJC") else {return UITableViewCell()}
        cell.configure(imgURL: url, title: selectedArticle.title, souceName: selectedArticle.source?.name, description: selectedArticle.description ?? "")
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedArticle = articles[indexPath.row]
        guard let urlToArticle = selectedArticle.url else{return}
        

        let vc = SFSafariViewController(url: URL(string:urlToArticle)!)
        present(vc, animated: true)
        
        
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
   
}



//
//  ResultsTable.swift
//  NewsTask
//
//  Created by Prabaljit Walia on 15/11/22.
//

import UIKit

class ResultsTable: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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

        networkManager.fetchNews(url: "https://newsapi.org/v2/everything?q=\(keyword)&apiKey=\(Constants.apiKey)") { data in
            self.articles = data
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //why??
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
        cell.textLabel?.text = "\(articles[indexPath.row].title)"
        cell.textLabel?.numberOfLines = 0
        guard let url = URL(string:articles[indexPath.row].urlToImage!) else {return UITableViewCell()}
        cell.configure(imgURL: url, text: articles[indexPath.row].title)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    

}


//
//  SourceResultsTableViewController.swift
//  NewsTask
//
//  Created by Prabaljit Walia on 18/11/22.
//

import UIKit
import SafariServices

class SourceResultsTableViewController: UIViewController {
    let tableView = UITableView()
    var keyword: String
    var source: String
    var networkManager = NewsNetworkManager()
    var articles:[Article] = [Article]()
    
    init(keyword: String,source: String) {
        self.source = source
        self.keyword = keyword
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View controller lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func setupView() {
        title = "Results for \(keyword)"
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
    }
    
    func fetchData() {
        networkManager.fetch(url: "\(Constants.baseAPI)/everything?q=\(keyword.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)&sources=\(source)&apiKey=\(Constants.apiKey)") { data in
            self.articles = data
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

private typealias TableViewDataSourceAndDelegates = SourceResultsTableViewController

extension TableViewDataSourceAndDelegates: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as? CustomTableViewCell else { return UITableViewCell()
        }
        let selectedArticle = articles[indexPath.row]
        guard let url = URL(string:selectedArticle.urlToImage ?? "https://ibb.co/7CWHTJC") else { return UITableViewCell() }
        cell.configure(imgURL: url, title: selectedArticle.title, souceName: selectedArticle.source?.name, description: selectedArticle.description ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedArticle = articles[indexPath.row]
        guard let urlToArticle = selectedArticle.url else { return }
        let vc = SFSafariViewController(url: URL(string:urlToArticle)!)
        present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
         200
    }
}

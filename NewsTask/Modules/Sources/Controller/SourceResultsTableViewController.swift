//
//  SourceResultsTableViewController.swift
//  NewsTask
//
//  Created by Prabaljit Walia on 18/11/22.
//

import UIKit
import SafariServices

class SourceResultsTableViewController: UIViewController {
    private let tableView = UITableView()
    private var keyword: String
    private var source: String
    private var networkManager = NewsNetworkManager()
    private var articles = [Article]()
    
    init(keyword: String, source: String) {
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
    
    // better to use constraints in future📝
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

private typealias TableViewDataSourceAndDelegates = SourceResultsTableViewController

extension TableViewDataSourceAndDelegates: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { articles.count  }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as? CustomTableViewCell else { return UITableViewCell()
        }
        
        // cleanup
        let selectedArticle = articles[indexPath.row]
        guard let url = URL(string:selectedArticle.urlToImage ?? "https://ibb.co/7CWHTJC") else { return UITableViewCell() }
        cell.setData(model: CustomCellModel(imgURL: url, title: selectedArticle.title, souceName: selectedArticle.source?.name, description: selectedArticle.description ?? ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedArticle = articles[indexPath.row]
        guard let urlToArticle = selectedArticle.url, let url = URL(string: urlToArticle) else { return }
        let safariView = SFSafariViewController(url: url)
        present(safariView, animated: true)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat { 200 }
}

private typealias ConfigureView = SourceResultsTableViewController

extension ConfigureView {
    private func setupView() {
        title = keyword 
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        setuptableView()
    }
    
    private func setuptableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
    }
    
    private func fetchData() {
        networkManager.fetch(url: "\(Constants.baseAPI)/everything?q=\(keyword.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)&sources=\(source)&apiKey=\(Constants.apiKey)") { [weak self] data in
            self?.articles = data
            self?.tableView.reloadData()
        }
    }
}

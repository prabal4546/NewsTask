//
//  ResultsTable.swift
//  NewsTask
//
//  Created by Prabaljit Walia on 15/11/22.
//

import UIKit
import SafariServices

class ResultsTableViewController: UIViewController {
    
    private var keyword: String
    private var sourceName: String?
    private var networkManager = NewsNetworkManager()
    private var articles = [Article]()
    private let tableView = UITableView()
    
    init(keyword: String) {
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
}

private typealias TableViewSetup = ResultsTableViewController
extension TableViewSetup: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as? CustomTableViewCell else { return UITableViewCell() }
        
        let selectedArticle = articles[indexPath.row]
        guard let url = URL(string: selectedArticle.urlToImage ?? "https://ibb.co/7CWHTJC") else { return UITableViewCell() }
        
        // Advanced - make - builder DESIGN PATTERN - where u can build
        // atleast make separate func that will return your cellModel
        cell.setData(model: CustomCellModel(imgURL: url,
                                              title: selectedArticle.title,
                                              souceName: selectedArticle.source?.name,
                                              description: selectedArticle.description ?? ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let urlToArticle = articles[indexPath.row].url,
              let url = URL(string: urlToArticle) else { return }
        
        let safariView = SFSafariViewController(url: url)
        present(safariView, animated: true)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat { 200 }
}

private typealias ConfigureView = ResultsTableViewController

extension ConfigureView {
    private func setupView() {
        view.backgroundColor = .systemBackground
        title = keyword
        view.addSubview(tableView)
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        // rowheight?? - automatic demension
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
    }
    
    // ✅why two calls ?? need to correct logic
    private func fetchData() {
        // Network Layer
        // ✅capture list ??
        networkManager.fetch(url: "\(Constants.baseAPI)/everything?q=\(keyword.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)&apiKey=\(Constants.apiKey)") { [weak self] data in
            self?.articles = data
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}


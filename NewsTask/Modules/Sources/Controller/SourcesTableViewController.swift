//
//  SourcesViewController.swift
//  NewsTask
//
//  Created by Prabaljit Walia on 18/11/22.
//

import UIKit
import SafariServices

class SourcesTableViewController: UIViewController {
    let tableView = UITableView()
    var category: String
    var networkManager = NewsNetworkManager()
    var sources: [Source] = [Source]()
    var keywordFromSearch: String
    
    init(category: String, keywordFromSearch: String) {
        self.category = category
        self.keywordFromSearch = keywordFromSearch
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    struct SourcesConstants {
        static let navButtonTitle = "Skip"
        static let cellIdentifier = "source-cell"
    }
    
    @objc func skipTapped() {
        self.navigationController?.pushViewController(ResultsTableViewController(keyword: keywordFromSearch), animated: true)
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
        view.backgroundColor = .systemBackground
        title = "\(keywordFromSearch) in \(category)"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: SourcesConstants.navButtonTitle, style: .plain, target: self, action: #selector(skipTapped))
        view.addSubview(tableView)
        setupTableView()
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SourcesTableViewCell.self, forCellReuseIdentifier: SourcesConstants.cellIdentifier)
    }
    
    func fetchData() {
        networkManager.fetchSources(url: "\(Constants.baseAPI)/top-headlines/sources?&apiKey=\(Constants.apiKey)") { [self] data in
            self.sources = data
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

private typealias TableViewDataSourceAndDelegates = SourcesTableViewController

extension TableViewDataSourceAndDelegates: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         sources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "source-cell", for: indexPath) as? SourcesTableViewCell else {
            return UITableViewCell()
        }
        let selectedSource = sources[indexPath.row]
        cell.configure(title: selectedSource.name!, description: selectedSource.description!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let sourceName = sources[indexPath.row].id
        self.navigationController?.pushViewController(SourceResultsTableViewController(keyword: keywordFromSearch, source: sourceName!), animated: true)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
         200
    }
}

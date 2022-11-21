//
//  SourcesViewController.swift
//  NewsTask
//
//  Created by Prabaljit Walia on 18/11/22.
//

import UIKit
import SafariServices

class SourcesViewController: UIViewController {

    var category:String
    var networkManager = NewsNetworkManager()
    var sources:[Source] = [Source]()
    var keywordFromSearch:String
    init(category: String, keywordFromSearch:String) {
        self.category = category
        self.keywordFromSearch = keywordFromSearch
        super.init(nibName: nil, bundle: nil)
    }
    // why?
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    let tableView = UITableView()
    
    @objc func skipTapped(){
        self.navigationController?.pushViewController(ResultsTableVC(keyword: keywordFromSearch), animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SourcesTableViewCell.self, forCellReuseIdentifier: "source-cell")
        title = "\(keywordFromSearch) in \(category)"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Skip", style: .plain, target: self, action: #selector(skipTapped))

        
        networkManager.fetchSources(url: "https://newsapi.org/v2/top-headlines/sources?&apiKey=\(Constants.apiKey)") { [self] data in
            self.sources = data
            print(sources)
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

    
}

extension SourcesViewController:UITableViewDelegate,UITableViewDataSource{
    // TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "source-cell", for: indexPath) as? SourcesTableViewCell else{return UITableViewCell()}

        let selectedSource = sources[indexPath.row]
        cell.configure(title: selectedSource.name!, description: selectedSource.description!)

//        cell.textLabel?.text = selectedSource.name
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let sourceName = sources[indexPath.row].id
        self.navigationController?.pushViewController(SourceResultsTableViewController(keyword: keywordFromSearch, source: sourceName!), animated: true)
        
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}

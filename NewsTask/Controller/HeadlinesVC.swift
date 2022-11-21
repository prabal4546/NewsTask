//
//  ThirdVC.swift
//  NewsTask
//
//  Created by Prabaljit Walia on 15/11/22.
//

import UIKit
import SafariServices

// TODO - Move Delegate DS to Extension

class HeadlinesVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {

    var networkManager = NewsNetworkManager()
    var articles: [Article] = [Article]()

    let tableView = UITableView()
    var pageNum = 1
    @objc func nextTapped(){
        pageNum += 1
        networkManager.fetch(url: "\(Constants.baseAPI)/top-headlines?country=in&pageSize=10&page=\(pageNum)&apiKey=\(Constants.apiKey)") { data in
            self.articles = data
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    @objc func prevTapped(){
        pageNum -= 1
        if pageNum == 0{
            print("1st page")
            let alert = UIAlertController(title: "Page 1", message: "You're on 1st page.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            networkManager.fetch(url: "\(Constants.baseAPI)/top-headlines?country=in&pageSize=10&page=\(pageNum)&apiKey=\(Constants.apiKey)") { data in
                self.articles = data
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        tableView.delegate = self
        tableView.dataSource = self
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Headlines"
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Prev", style: .plain, target: self, action: #selector(prevTapped))

        // FIX ME: -
        networkManager.fetch(url: "\(Constants.baseAPI)/top-headlines?country=in&pageSize=10&page=\(pageNum)&apiKey=\(Constants.apiKey)") { data in
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }

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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (tableView.contentSize.height-100)-scrollView.frame.size.height{
            guard !networkManager.isPaginating else{return}
            self.tableView.tableFooterView = createSpinnerFooter()
            networkManager.fetch(pagination:true, url: "\(Constants.baseAPI)/top-headlines?country=in&pageSize=10&page=\(pageNum+1)&apiKey=\(Constants.apiKey)") {[weak self] result in
                self?.pageNum += 1
                DispatchQueue.main.async {
                    self?.tableView.tableFooterView = nil
                }
                
                self?.articles.append(contentsOf: result)
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }
    func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        spinner.startAnimating()
        footerView.addSubview(spinner)
        return footerView
    }

}



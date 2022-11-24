import UIKit
import SafariServices

class HeadlinesViewController: UIViewController {
    private var networkManager = NewsNetworkManager()
    private var articles = [Article]()
    private let tableView = UITableView()
    private var pageNumber = 1 // Page Number✅
    
    struct HeadlineConstants {
        static let navTitle = "Headlines"
        static let next = "Next"
        static let prev = "Prev"
        static let alertTitle = "Page 1"
        static let alertMessage = "You're on 1st page."
        static let alertActionTitle = "OK"
    }
    
    // MARK: - View controller lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // cleanup this✅
        setupView()
        fetchData()
    }
    
    // learn about this func - and its usage
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func fetchData() {
        networkManager.fetch(url: "\(Constants.baseAPI)/top-headlines?country=in&pageSize=10&page=\(pageNumber)&apiKey=\(Constants.apiKey)") { [weak self] data in
            self?.articles = data
            self?.tableView.reloadData()
        }
    }
    
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        spinner.startAnimating()
        footerView.addSubview(spinner)
        return footerView
    }
}

// MARK: - TABLE VIEW DELEGATE
private typealias TableViewDataSourceAndDelegates = HeadlinesViewController

extension TableViewDataSourceAndDelegates: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.identifier, for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }
        let selectedArticle = articles[indexPath.row]
        guard let url = URL(string:selectedArticle.urlToImage ?? "https://ibb.co/7CWHTJC") else { return UITableViewCell() }
        cell.setData(model: CustomCellModel(imgURL: url, title: selectedArticle.title, souceName: selectedArticle.source?.name, description: selectedArticle.description ?? ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let urlToArticle = articles[indexPath.row].url else { return }
        let safariView = SFSafariViewController(url: URL(string:urlToArticle)!)
        present(safariView, animated: true)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat { 200 }
}

// MARK: - SCROLL VIEW DELEGATE
private typealias ScrollViewDelegate = HeadlinesViewController

extension ScrollViewDelegate:UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (tableView.contentSize.height-100)-scrollView.frame.size.height {
            guard !networkManager.isFetching else { return }
            self.tableView.tableFooterView = createSpinnerFooter()
            networkManager.fetch(pagination:true, url: "\(Constants.baseAPI)/top-headlines?country=in&pageSize=10&page=\(pageNumber+1)&apiKey=\(Constants.apiKey)") { [weak self] result in
                self?.pageNumber += 1
                
                //use one async eventually drive it from network layer
                self?.tableView.tableFooterView = nil
                self?.articles.append(contentsOf: result)
                self?.tableView.reloadData()
            }
        }
    }
}

private typealias ConfigureView = HeadlinesViewController

extension ConfigureView {
    func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        setupTable()
        setupNavBar()
    }
    
    func setupTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = HeadlineConstants.navTitle
    }
}

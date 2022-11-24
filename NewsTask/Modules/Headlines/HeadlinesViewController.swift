import UIKit
import SafariServices

class HeadlinesViewController: UIViewController {
    var networkManager = NewsNetworkManager()
    var articles: [Article] = [Article]()
    let tableView = UITableView()
    var pageNum = 1
    
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
        networkManager.fetch(url: "\(Constants.baseAPI)/top-headlines?country=in&pageSize=10&page=\(pageNum)&apiKey=\(Constants.apiKey)") { data in
            self.articles = data
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
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
        cell.configure(model: CustomCellModel(imgURL: url, title: selectedArticle.title, souceName: selectedArticle.source?.name, description: selectedArticle.description ?? ""))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedArticle = articles[indexPath.row]
        guard let urlToArticle = selectedArticle.url else { return }
        let vc = SFSafariViewController(url: URL(string:urlToArticle)!)
        present(vc, animated: true)
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
            networkManager.fetch(pagination:true, url: "\(Constants.baseAPI)/top-headlines?country=in&pageSize=10&page=\(pageNum+1)&apiKey=\(Constants.apiKey)") { [weak self] result in
                self?.pageNum += 1
                
                //use one async eventually drive it from network layer
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
    }
    
    func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = HeadlineConstants.navTitle
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: HeadlineConstants.next, style: .plain, target: self, action: #selector(nextTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: HeadlineConstants.prev, style: .plain, target: self, action: #selector(prevTapped))
    }
}

private typealias NavigationBarItemActions = HeadlinesViewController
extension NavigationBarItemActions {
    @objc func nextTapped() {
        pageNum += 1
        networkManager.fetch(url: "\(Constants.baseAPI)/top-headlines?country=in&pageSize=10&page=\(pageNum)&apiKey=\(Constants.apiKey)") { data in
            self.articles = data
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func prevTapped() {
        pageNum -= 1
        if pageNum == 0 {
            let alert = UIAlertController(title: HeadlineConstants.alertTitle, message: HeadlineConstants.alertMessage, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: HeadlineConstants.alertActionTitle, style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            networkManager.fetch(url: "\(Constants.baseAPI)/top-headlines?country=in&pageSize=10&page=\(pageNum)&apiKey=\(Constants.apiKey)") { data in
                self.articles = data
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

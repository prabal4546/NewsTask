//
//  HomeVC.swift
//  NewsTask
//
//  Created by Prabaljit Walia on 15/11/22.
//

import UIKit

class HomeVC: UIViewController {
    var networkManager = NewsNetworkManager()
    var selectedCategory = ""
    let categoriesData = ["business","entertainment","general","health","science","sports","technology"]

    // MARK: - UI
    private var searchField:UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Search"
        textfield.borderStyle = .roundedRect
        textfield.layer.cornerRadius = 10
        
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    private var businessBtn:UIButton = {
        let button = UIButton()
        button.setTitle("Business", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.green, for:.highlighted)
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    private var categoryStack:UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 10
        return stackView
    }()
    private var selectCategoryLabel:UILabel = {
        let label = UILabel()
        label.text = "Select a category"
        return label
    }()
    private var categoryTableView:UITableView = {
       let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()

    
    func setupConstraints() {
        let p20:CGFloat = 20
        let p40:CGFloat = 40
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: safeArea.topAnchor,constant: p20),
            searchField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,constant:p40),
            searchField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,constant: -p40)
        ])
        //        NSLayoutConstraint.activate([
        //            stackView.topAnchor.constraint(equalTo: searchField.bottomAnchor,constant: 10),
        //            stackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: p40),
        //            stackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,constant: -p40),
        //            stackView.heightAnchor.constraint(equalToConstant: 50)
        //        ])

//        NSLayoutConstraint.activate([
//            businessBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            businessBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        ])
        
        NSLayoutConstraint.activate([
            categoryTableView.topAnchor.constraint(equalTo: searchField.bottomAnchor,constant: p40),
            categoryTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: p40),
            categoryTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -p40),
            categoryTableView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    func setupView(){
        view.addSubview(searchField)
//        view.addSubview(businessBtn)
        view.addSubview(categoryTableView)
        searchField.delegate = self
        businessBtn.addTarget(self, action: #selector(categoryTapped), for: .touchUpInside)


    }
    @objc func categoryTapped(){
        print("tapped")
        selectedCategory = "business"
//        self.navigationController?.pushViewController(ResultsTableVC(keyword: "business"), animated: true)
//        self.navigationController?.pushViewController(SourcesViewController(keyword: "business"), animated: true)

    }

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Search"
        setupView()
        setupConstraints()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        categoryTableView.register(UITableViewCell.self, forCellReuseIdentifier: "categories-cell")
    }
    override func viewWillAppear(_ animated: Bool) {
        searchField.text = ""
    }
    
}

extension HomeVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchField.endEditing(true)
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchField.text != ""{
            return true
        }else{
            searchField.placeholder = "Type something"
            return false
        }
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let keyword = searchField.text {
            if selectedCategory == ""{
                let alert = UIAlertController(title: "No Category selected", message: "Please select a category before proceeding with search.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)

            }else{
                self.navigationController?.pushViewController(SourcesViewController(category: selectedCategory, keywordFromSearch: keyword), animated: true)

            }
        }
    }
}
extension HomeVC:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categories-cell", for: indexPath)
        cell.textLabel?.text = categoriesData[indexPath.row]
        cell.textLabel?.textColor = .black
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCategory = categoriesData[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Select a Category"
    }
}

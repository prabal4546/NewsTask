//
//  HomeVC.swift
//  NewsTask
//
//  Created by Prabaljit Walia on 15/11/22.
//

import UIKit

class HomeVC: UIViewController {
    var networkManager = NewsNetworkManager()
    
    // MARK: - UI
    private var searchField:UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Search"
        textfield.borderStyle = .roundedRect
        textfield.layer.cornerRadius = 10
        
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    private var categoryBtn:UIButton = {
        let button = UIButton()
        button.setTitle("Business", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
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
    func setupView(){
        view.addSubview(searchField)
        //        view.addSubview(stackView)
        view.addSubview(categoryBtn)
    }
    
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

        NSLayoutConstraint.activate([
            categoryBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            categoryBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    @objc func categoryTapped(){
        print("tapped")
        self.navigationController?.pushViewController(ResultsTableVC(keyword: "business"), animated: true)
    }

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Search"
        setupView()
        setupConstraints()
        searchField.delegate = self
        view.backgroundColor = .systemBackground
        categoryBtn.addTarget(self, action: #selector(categoryTapped), for: .touchUpInside)
        
        navigationController?.navigationBar.prefersLargeTitles = true
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
            self.navigationController?.pushViewController(ResultsTableVC(keyword: keyword), animated: true)
        }
    }
}

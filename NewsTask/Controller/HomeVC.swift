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
    
    func setupView(){
        view.addSubview(searchField)
    }
    
    func setupConstraints() {
        let p20:CGFloat = 20
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: safeArea.topAnchor,constant: p20),
            searchField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,constant:40),
            searchField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,constant: -40)
        ])
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Home"
        setupView()
        setupConstraints()
        searchField.delegate = self
        view.backgroundColor = .systemBackground
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
        searchField.text = ""
    }
}

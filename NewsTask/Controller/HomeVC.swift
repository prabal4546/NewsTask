//
//  HomeVC.swift
//  NewsTask
//
//  Created by Prabaljit Walia on 15/11/22.
//

import UIKit

class HomeVC: UIViewController {
    
    // MARK: - UI
    private var searchField:UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Search"
        textfield.borderStyle = .roundedRect
        textfield.layer.cornerRadius = 10
        
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            
        ])
    }
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Home"
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
        if let city = searchField.text {
            // do something
            
        }
    }
}

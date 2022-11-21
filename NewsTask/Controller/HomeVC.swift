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
    let categoriesData = ["business","entertainment","general","health","science","sports","technology","business","entertainment","general","health","science","sports","technology"]
    
    let debouncer = Debouncer(timeInterval: 0.5)

    // MARK: - UI
    private var searchField:UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Search"
        textfield.borderStyle = .roundedRect
        textfield.layer.cornerRadius = 10
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    private var showDropDownBtn:UIButton = {
        let button = UIButton()
        button.setTitle("Categories", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
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

        NSLayoutConstraint.activate([
            showDropDownBtn.bottomAnchor.constraint(equalTo: categoryTableView.topAnchor),
            showDropDownBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: p40),
            showDropDownBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -p40),
            showDropDownBtn.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            categoryTableView.topAnchor.constraint(equalTo: searchField.bottomAnchor,constant: p40),
            categoryTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoryTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoryTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
    func setupView(){
        view.addSubview(searchField)
        view.addSubview(categoryTableView)
        view.addSubview(showDropDownBtn)
        searchField.delegate = self
        showDropDownBtn.addTarget(self, action: #selector(categoryTapped), for: .touchUpInside)
    }
    
    @objc func categoryTapped(){
        if categoryTableView.isHidden {
                   animate(toggle: true, type: showDropDownBtn)
              } else {
                   animate(toggle: false, type: showDropDownBtn)
              }
    }

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Search"
        searchField.addTarget(self, action: #selector(HomeVC.textFieldDidChange), for: .editingChanged)

        setupView()
        setupConstraints()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        categoryTableView.layer.cornerRadius = 5
        categoryTableView.register(UITableViewCell.self, forCellReuseIdentifier: "categories-cell")
    }
    override func viewWillAppear(_ animated: Bool) {
        searchField.text = ""
//        selectedCategory = ""
        categoryTableView.reloadData()
    }
    
}

extension HomeVC: UITextFieldDelegate{
    @objc func textFieldDidChange(){
        debouncer.renewInterval()
        debouncer.handler = {
//            self.textFieldDidEndEditing(self.searchField)
            if let keyword = self.searchField.text{
                if self.selectedCategory == ""{
                    let alert = UIAlertController(title: "No Category selected", message: "Please select a category before proceeding with search.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }else{
                    self.navigationController?.pushViewController(SourcesViewController(category: self.selectedCategory, keywordFromSearch: keyword), animated: true)
                }
            }
        }
    }
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
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if let keyword = searchField.text {
//            if selectedCategory == ""{
//                let alert = UIAlertController(title: "No Category selected", message: "Please select a category before proceeding with search.", preferredStyle: UIAlertController.Style.alert)
//                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
//                self.present(alert, animated: true, completion: nil)
//
//            }else{
//                self.navigationController?.pushViewController(SourcesViewController(category: self.selectedCategory, keywordFromSearch: keyword), animated: true)
//            }
//        }
//    }
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let currentText = searchField.text ?? ""
//        guard let stringRange = Range(range, in: currentText) else { return false }
//        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
//        if updatedText.count >= 5{
//           // textFieldDidEndEditing(searchField)
//        }else if selectedCategory == ""{
//            let alert = UIAlertController(title: "No Category selected", message: "Please select a category before proceeding with search.", preferredStyle: UIAlertController.Style.alert)
//            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }
//        return updatedText.count <= 5
//    }
    
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
        showDropDownBtn.setTitle(selectedCategory, for: .normal)
        animate(toggle: false, type: showDropDownBtn)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Select a Category"
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "End of Categories"
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.yellow
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        view.tintColor = .yellow
    }
}

extension HomeVC{
    func animate(toggle: Bool, type: UIButton) {
             
           if type == showDropDownBtn {
                 
               if toggle {
                   UIView.animate(withDuration: 0.3) {
                       self.categoryTableView.isHidden = false
                   }
               } else {
                   UIView.animate(withDuration: 0.3) {
                       self.categoryTableView.isHidden = true
                   }
               }
           } else {
               if toggle {
                   UIView.animate(withDuration: 0.3) {
                       self.categoryTableView.isHidden = false
                   }
               } else {
                   UIView.animate(withDuration: 0.3) {
                       self.categoryTableView.isHidden = true
                   }
               }
           }
    }
}

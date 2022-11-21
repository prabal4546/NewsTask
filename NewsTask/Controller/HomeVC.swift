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
    
    let debouncer = Debouncer(timeInterval: 0.3)

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
        button.setTitle("Drop", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.backgroundColor = .lightGray
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

        NSLayoutConstraint.activate([
//            showDropDownBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            showDropDownBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            showDropDownBtn.bottomAnchor.constraint(equalTo: categoryTableView.topAnchor),
            showDropDownBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: p40),
            showDropDownBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -p40),
            showDropDownBtn.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            categoryTableView.topAnchor.constraint(equalTo: searchField.bottomAnchor,constant: p40),
            categoryTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: p40),
            categoryTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -p40),
            categoryTableView.heightAnchor.constraint(equalToConstant: 200)
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
        print("tapped")
        if categoryTableView.isHidden {
                   animate(toogle: true, type: showDropDownBtn)
              } else {
                   animate(toogle: false, type: showDropDownBtn)
              }
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
        categoryTableView.layer.cornerRadius = 5
        categoryTableView.register(UITableViewCell.self, forCellReuseIdentifier: "categories-cell")
    }
    override func viewWillAppear(_ animated: Bool) {
        searchField.text = ""
        selectedCategory = ""
        categoryTableView.reloadData()
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

                self.navigationController?.pushViewController(SourcesViewController(category: self.selectedCategory, keywordFromSearch: keyword), animated: true)


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
        showDropDownBtn.setTitle(selectedCategory, for: .normal)
        animate(toogle: false, type: showDropDownBtn)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Select a Category"
    }
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "End of Categories"
    }
    
}

extension HomeVC{
    func animate(toogle: Bool, type: UIButton) {
             
           if type == showDropDownBtn {
                 
               if toogle {
                   UIView.animate(withDuration: 0.3) {
                       self.categoryTableView.isHidden = false
                   }
               } else {
                   UIView.animate(withDuration: 0.3) {
                       self.categoryTableView.isHidden = true
                   }
               }
           } else {
               if toogle {
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
    func setupSearchFieldListeners(){
//        let publisher = NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: searchField)
//        publisher.map{
//            (
//                $0.object as! UITextField
//            ).text
//        }.debounce(for: .milliseconds(500), scheduler: RunLoop.main)
//        .sink { (str) in
//            print(str ?? "")
//        }
        let textFieldPublisher = NotificationCenter.default
                    .publisher(for: UITextField.textDidChangeNotification, object: searchField)
                    .map( {
                        ($0.object as? UITextField)?.text
                    })
                
                textFieldPublisher
                    .receive(on: RunLoop.main)
                    .sink(receiveValue: { [weak self] value in
                        print("UITextField.text changed to: \(value)")
                    })

    }
}

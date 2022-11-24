//
//  HomeVC.swift
//  NewsTask
//
//  Created by Prabaljit Walia on 15/11/22.
//

import UIKit

class HomeViewController: UIViewController {
    
    private var networkManager = NewsNetworkManager()
    private var selectedCategory = ""
    private let categoriesData = Constants.categoriesData
    private let debouncer = Debouncer(timeInterval: 0.5)
    
    struct Constants {
        static let cellIdentifier = "categories-cell"
        static let categoryStart = "Select a Category"
        static let categoryEnd = "End of Categories"
        static let categories = "Categories"
        static let selectCategory = "Select a category"
        static let search = "Search"
        static let alertTitle = "No Category selected"
        static let alertMessage = "Please select a category before proceeding with search."
        static let alertActionTitle = "Ok"
        static let placeholder = "Type something"
        static let categoriesData = ["business","entertainment","general","health","science","sports","technology","business","entertainment","general","health","science","sports","technology"]
        
    }
    
    // MARK: - UI Elements
    private var searchField: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = Constants.search
        textfield.borderStyle = .roundedRect
        textfield.layer.cornerRadius = 10
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    private var showDropDownBtn: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.categories, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.backgroundColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var selectCategoryLabel: UILabel = {
        let label = UILabel()
        label.text = Constants.selectCategory // ✅constants
        return label
    }()
    
    private var categoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.keyboardDismissMode = .onDrag // read about this
        return tableView
    }()
    
    // identation
    // ✅ use ? _ : _
    @objc func categoryTapped() {
        animate(toggle: categoryTableView.isHidden)
    }
    
    // MARK: - View controller lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // ✅clean this didload
        configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchField.text = ""
        categoryTableView.reloadData()
    }
}

// Spacing
//✅ typealias
// constants
private typealias TextFieldMethods = HomeViewController
extension TextFieldMethods: UITextFieldDelegate {
    @objc func textFieldDidChange() {
        debouncer.renewInterval()
        debouncer.handler = { [weak self] in
            if let keyword = self?.searchField.text {
                // ✅make String+extension file under common folders - then make isEmpty() function (refer stackoverflow)
                // ✅make a function which will tell u whether to present or push
                self?.presentSources(keyword: keyword)
            }
        }
    }
    
    private func presentSources(keyword:String) {
        //✅ dont use unneecessary self
        if selectedCategory.isEmpty {
            //✅ constants
            let alert = UIAlertController(title: Constants.alertTitle,
                                          message: Constants.alertMessage,
                                          preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: Constants.alertActionTitle, style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            //use isNonEmpty()
            // optional bool
        } else if searchField.text?.isEmpty == false  {
            self.navigationController?.pushViewController(SourcesTableViewController(category: selectedCategory, keywordFromSearch: keyword), animated: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // TODO: make optional string extension - check stackoverflow  (for nonEmpty() )
        if searchField.text != "" {
            return true
        } else {
            searchField.placeholder = Constants.placeholder
            return false
        }
    }
}

//MARK: - Tableview related methods
private typealias TableViewDataSourceAndDelegates = HomeViewController

extension TableViewDataSourceAndDelegates: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { categoriesData.count }
    // ✅remove return statement whenever 1 LOC
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // as of now - its fine to use Apple's defined cell
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath) // put in constant
        cell.textLabel?.text = categoriesData[indexPath.row]
        cell.textLabel?.textColor = .black
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCategory = categoriesData[indexPath.row]
        showDropDownBtn.setTitle(selectedCategory, for: .normal)
        animate(toggle: false)
    }
    
    // ✅One line
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { Constants.categoryStart // ✅put in constants
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? { Constants.categoryEnd }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) { view.tintColor = UIColor.yellow }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) { view.tintColor = .yellow }
}

// ✅Use typealias
private typealias DropDownButton = HomeViewController

extension DropDownButton {
    //✅ check parameters
    // paramter name can be more descriptive ??
    private func animate(toggle: Bool) {
        // TODO:
        // ✅same duplicate code - check it : if different then u can use switch case
        UIView.animate(withDuration: 0.3) {
            self.categoryTableView.isHidden = !toggle
        }
    }
}

// MARK: - CONFIGURE VIEW
private typealias ConfigureView = HomeViewController

extension ConfigureView {
    // ✅cnfureViews from viewDIdload -> setUpview (has serachBarSetup() and tableviewswtup())
    // ✅extension
    private func configureViews() {
        setupView()
        searchBarSetup()
        tableViewSetup()
        dropDownAction()
    }
    
    private func setupView() {
        view.addSubview(searchField)
        view.addSubview(categoryTableView)
        view.addSubview(showDropDownBtn)
        
        setupConstraints()
        screenSetup()
    }
    
    private func searchBarSetup() {
        searchField.delegate = self
        searchField.addTarget(self, action: #selector(Self.textFieldDidChange), for: .editingChanged)
    }
    
    private func tableViewSetup() {
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        categoryTableView.layer.cornerRadius = 4
        categoryTableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cellIdentifier)
    }
    
    private func dropDownAction() {
        showDropDownBtn.addTarget(self, action: #selector(categoryTapped), for: .touchUpInside)
    }
    
    private func screenSetup() {
        title = Constants.search
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    //✅ [better to put this in separate extension
    private func setupConstraints() {
        let p20: CGFloat = 20
        let p40: CGFloat = 40
        let safeArea = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: safeArea.topAnchor,constant: p20),
            searchField.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor,constant: p40),
            searchField.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor,constant: -p40)
        ])
        
        NSLayoutConstraint.activate([
            showDropDownBtn.bottomAnchor.constraint(equalTo: categoryTableView.topAnchor),
            showDropDownBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: p40),
            showDropDownBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -p40),
            showDropDownBtn.heightAnchor.constraint(equalToConstant: p20)
        ])
        
        NSLayoutConstraint.activate([
            categoryTableView.topAnchor.constraint(equalTo: searchField.bottomAnchor,constant: p40),
            categoryTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoryTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoryTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
}

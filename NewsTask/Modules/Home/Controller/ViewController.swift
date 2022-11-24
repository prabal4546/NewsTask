//
//  ViewController.swift
//  NewsTask
//
//  Created by Prabaljit Walia on 14/11/22.
//

import UIKit

class ViewController: UIViewController {
    // MARK: - UI
    private var tabBarView: UITabBarController = {
        let tabBarVC = UITabBarController()
       // ✅setupTabBar function in extension
        return tabBarVC
    }()
    
    // MARK: - View controller lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // again use separate methods✅
        setTabBarAppearance()
    }
    
    // ✅check the logicals here
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        present(tabBarView, animated: true)
    }
    
    // MARK: - SET UP
    private func setTabBarAppearance() {
        UITabBar.appearance().barTintColor = .systemBackground
        tabBarView.tabBar.tintColor = .label
        setupTabBar()
    }
    
    struct Constants {
        static let firstTabTitle = "Search"
        static let secondTabTitle = "Map"
        static let thirdTabTitle = "News"
    }
}

private typealias TabBarSetup = ViewController
extension TabBarSetup {
    private func setupTabBar() {
        let firstTab = UINavigationController(rootViewController: HomeViewController())
        let secondTab = UINavigationController(rootViewController: MapViewController())
        let thirdTab = UINavigationController(rootViewController: HeadlinesViewController())
       
        firstTab.title = Constants.firstTabTitle
        secondTab.title = Constants.secondTabTitle
        thirdTab.title = Constants.thirdTabTitle
        
        tabBarView.setViewControllers([firstTab, secondTab, thirdTab], animated: false)
        setTabItemSymbols()
        tabBarView.modalPresentationStyle = .fullScreen
        tabBarView.tabBar.backgroundColor = .clear
    }
    
    private func setTabItemSymbols() {
        guard let items = tabBarView.tabBar.items else { return }
        let images = ["magnifyingglass", "map", "newspaper"]
        // use enumeration
        for (key, value) in items.enumerated() {
            value.image = UIImage(systemName: images[key])
        }
    }
}

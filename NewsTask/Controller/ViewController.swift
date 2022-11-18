//
//  ViewController.swift
//  NewsTask
//
//  Created by Prabaljit Walia on 14/11/22.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - UI
    private var tabBarView:UITabBarController = {
        let tabBarVC = UITabBarController()
        
        let vc1 = UINavigationController(rootViewController: HomeVC())
        let vc2 = UINavigationController(rootViewController: MapVC())
        let vc3 = UINavigationController(rootViewController: HeadlinesVC())
        
        vc1.title = "Search"
        vc2.title = "Map"
        vc3.title = "News"
        
        tabBarVC.setViewControllers([vc1,vc2,vc3], animated: false)
        tabBarVC.modalPresentationStyle = .fullScreen
        tabBarVC.tabBar.backgroundColor = .clear
        return tabBarVC
    }()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        UITabBar.appearance().barTintColor = .systemBackground
        tabBarView.tabBar.tintColor = .label
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupTabBar()
    }
    // MARK: - SET UP
    func setupTabBar(){
        present(tabBarView, animated: true)
        guard let items = tabBarView.tabBar.items else{return}
        let images = ["magnifyingglass","map","newspaper"]
        for i in 0..<items.count{
            items[i].image = UIImage(systemName: images[i])
        }
    }
    
    
}


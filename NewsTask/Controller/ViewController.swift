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
        let vc2 = UINavigationController(rootViewController: SecondVC())
        let vc3 = UINavigationController(rootViewController: ThirdVC())
        vc1.title = "Home"
        vc2.title = "Second"
        vc3.title = "Third"
        tabBarVC.setViewControllers([vc1,vc2,vc3], animated: false)
                
        tabBarVC.modalPresentationStyle = .fullScreen
        return tabBarVC
    }()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupTabBar()
    }
    // MARK: - SET UP
    func setupTabBar(){
        present(tabBarView, animated: true)
                guard let items = tabBarView.tabBar.items else{return}
                let images = ["house","newspaper","gearshape"]
                for i in 0..<items.count{
                    items[i].image = UIImage(systemName: images[i])
                }
    }


}


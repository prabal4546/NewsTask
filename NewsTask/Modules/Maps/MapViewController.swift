//
//  SecondVC.swift
//  NewsTask
//
//  Created by Prabaljit Walia on 15/11/22.
//

import UIKit

class MapViewController: UIViewController {
    struct Constants {
        static let navTitle = "Map"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // ✅separate func
        setupView()
    }
    
    private func setupView() {
        title = Constants.navTitle
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

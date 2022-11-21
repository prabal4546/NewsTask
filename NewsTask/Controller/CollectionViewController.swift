//
//  CollectionViewViewController.swift
//  NewsTask
//
//  Created by Prabaljit Walia on 20/11/22.
//

import UIKit

class CollectionViewController: UIViewController {
    let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        layout.scrollDirection = .horizontal
        //why self on right
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cv-cell")
        return cv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    func setupView(){
        view.addSubview(collectionView)
        collectionView.backgroundColor = .white
    }
    func setupConstraints(){
        let p40:CGFloat = 40
        NSLayoutConstraint.activate([
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -p40),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: p40),
            collectionView.heightAnchor.constraint(equalTo: collectionView.widthAnchor,multiplier: 0.5),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -p40)
        ])
    }

}
extension CollectionViewController:UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cv-cell", for: indexPath)
        cell.backgroundColor = .red
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/2.5, height: collectionView.frame.height/2.5)
    }
    
}

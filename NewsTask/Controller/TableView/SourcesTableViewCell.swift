//
//  SourcesTableViewCell.swift
//  NewsTask
//
//  Created by Prabaljit Walia on 18/11/22.
//

import UIKit

class SourcesTableViewCell: UITableViewCell {
    
    static let identifier = "source-cell"
    
    // MARK: - UI
    let headlineLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()

    let descLabel:UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        return label
    }()
    
    let cellView:UIView = {
        let myView = UIView()
        
        return myView
    }()
    // MARK: - ViewLifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
        setupView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setupView(){
        addSubview(headlineLabel)
        addSubview(descLabel)
        setupConstraints()
    }
    func setupConstraints(){
        NSLayoutConstraint.activate([
            headlineLabel.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -5),
            headlineLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 5),
            headlineLabel.topAnchor.constraint(equalTo: topAnchor,constant: 5)
            
        ])
        
        NSLayoutConstraint.activate([
            descLabel.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor,constant: 2),
            descLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            descLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 5),
            descLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

    }
    // MARK: - Config
    public func configure(title:String, description:String){
        headlineLabel.text = title

        descLabel.text = description
        
        
    }
}

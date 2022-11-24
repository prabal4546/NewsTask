//
//  SourcesTableViewCell.swift
//  NewsTask
//
//  Created by Prabaljit Walia on 18/11/22.
//

import UIKit

class SourcesTableViewCell: UITableViewCell {
    
    static let identifier = "source-cell"
    
    // MARK: - UI Elements
    private let headlineLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()

    private let descLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        return label
    }()
    
    let cellView: UIView = {
        let myView = UIView()
        return myView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private typealias Configure = SourcesTableViewCell

extension Configure {
    private func setupView() {
        contentView.backgroundColor = .systemBackground
        addSubview(headlineLabel)
        addSubview(descLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        let p4: CGFloat = 4
        let p2: CGFloat = 2
        
        NSLayoutConstraint.activate ([
            headlineLabel.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -p4),
            headlineLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: p4),
            headlineLabel.topAnchor.constraint(equalTo: topAnchor,constant: p4)
        ])
        
        NSLayoutConstraint.activate ([
            descLabel.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor,constant: p2),
            descLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -p4),
            descLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: p4),
            descLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    public func configure(title: String, description: String) {
        headlineLabel.text = title
        descLabel.text = description
    }
}

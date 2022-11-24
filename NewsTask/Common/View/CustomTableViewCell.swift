//
//  CustomTableViewCell.swift
//  NewsTask
//
//  Created by Prabaljit Walia on 16/11/22.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    var imageURL:String?
    static let identifier = "CustomTableViewCell"
    static let fallbackName = "Not working"
    
    // MARK: - UI Elements
    private let articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private let headlineLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private let sourceName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .gray
        label.font = UIFont.preferredFont(forTextStyle: .caption2)
        return label
    }()
    
    private let descLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Config
    // replace with model
    typealias Model = CustomTableViewCellModel
    public func configure(imgURL: URL, title: String, souceName: String?, description: String) {
        headlineLabel.text = title
        if let source = souceName {
            sourceName.text = source
        }
        else {
            sourceName.text = CustomTableViewCell.fallbackName
        }
        descLabel.text = description
        load(from: imgURL) { data in
            guard let cellImage = UIImage(data: data) else{return}
            DispatchQueue.main.async {
                self.articleImageView.image = cellImage
            }
        }
    }
    
    private func load(from url: URL, completion: @escaping (Data)->()) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                completion(data)
            }
        }
    }
}

private typealias ConfigureView = CustomTableViewCell
extension ConfigureView {
    private func setupView() {
        addSubview(articleImageView)
        addSubview(headlineLabel)
        addSubview(sourceName)
        addSubview(descLabel)
        backgroundColor = .clear
        addShadow()
        setupConstraints()
    }
    
    private func addShadow() {
        contentView.layer.cornerRadius = 10.0
        contentView.layer.masksToBounds = true
        layer.masksToBounds = false
        layer.shadowOpacity = 0.20
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = UIColor.black.cgColor
    }
    
    private func setupConstraints() {
        let p5: CGFloat = 5
        let p70: CGFloat = 70
        let p2: CGFloat = 2
        
        NSLayoutConstraint.activate([
            articleImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -p5),
            articleImageView.heightAnchor.constraint(equalToConstant: p70),
            articleImageView.widthAnchor.constraint(equalTo: articleImageView.heightAnchor,multiplier: 16/9),
            articleImageView.topAnchor.constraint(equalTo: topAnchor,constant: p5)
        ])
        
        NSLayoutConstraint.activate([
            headlineLabel.trailingAnchor.constraint(equalTo: articleImageView.leadingAnchor,constant: -p5),
            headlineLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: p5),
            headlineLabel.topAnchor.constraint(equalTo: topAnchor,constant: p5)
        ])
        
        NSLayoutConstraint.activate([
            descLabel.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor,constant: p2),
            descLabel.bottomAnchor.constraint(equalTo: sourceName.topAnchor),
            descLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: p5),
            descLabel.trailingAnchor.constraint(equalTo: articleImageView.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            sourceName.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -p5),
            sourceName.leadingAnchor.constraint(equalTo: leadingAnchor,constant: p5),
            sourceName.trailingAnchor.constraint(equalTo: articleImageView.leadingAnchor)
        ])
    }
}


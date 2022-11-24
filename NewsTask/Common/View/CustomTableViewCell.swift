//
//  CustomTableViewCell.swift
//  NewsTask
//
//  Created by Prabaljit Walia on 16/11/22.
//

import UIKit

struct CustomCellModel {
    let imgURL: URL
    let title: String
    let souceName: String?
    let description: String
}

class CustomTableViewCell: UITableViewCell {
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
    // ✅replace with model
    // ✅replace with setData - configure is also fine but in our code base we use setData
    public func setData(model: CustomCellModel) {
        headlineLabel.text = model.title
        sourceName.text = model.souceName ?? CustomTableViewCell.fallbackName
        descLabel.text = model.description
        load(from: model.imgURL) { data in
            guard let cellImage = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.articleImageView.image = cellImage
            }
        }
    }
    
    private func load(from url: URL, completion: @escaping (Data) -> ()) {
        DispatchQueue.global().async {
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
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = UIColor.black.cgColor
    }
    
    private func setupConstraints() {
        let p4: CGFloat = 4 // future m only we have even number in padding like 4, 8, 12, 16
        let p70: CGFloat = 70
        let p2: CGFloat = 2
        
        NSLayoutConstraint.activate([
            articleImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -p4),
            articleImageView.heightAnchor.constraint(equalToConstant: p70),
            articleImageView.widthAnchor.constraint(equalTo: articleImageView.heightAnchor, multiplier: 16/9),
            articleImageView.topAnchor.constraint(equalTo: topAnchor,constant: p4)
        ])
        
        NSLayoutConstraint.activate([
            headlineLabel.trailingAnchor.constraint(equalTo: articleImageView.leadingAnchor, constant: -p4),
            headlineLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: p4),
            headlineLabel.topAnchor.constraint(equalTo: topAnchor,constant: p4)
        ])
        
        NSLayoutConstraint.activate([
            descLabel.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: p2),
            descLabel.bottomAnchor.constraint(equalTo: sourceName.topAnchor),
            descLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: p4),
            descLabel.trailingAnchor.constraint(equalTo: articleImageView.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            sourceName.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -p4),
            sourceName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: p4),
            sourceName.trailingAnchor.constraint(equalTo: articleImageView.leadingAnchor)
        ])
    }
}


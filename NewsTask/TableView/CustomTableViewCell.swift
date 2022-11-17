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
    
    // MARK: - UI
     let articleImageView:UIImageView = {
        let imageView = UIImageView()
         imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
         imageView.translatesAutoresizingMaskIntoConstraints = false
         imageView.layer.cornerRadius = 10
        return imageView
    }()
    let headlineLabel:UILabel = {
    let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    let sourceName:UILabel = {
    let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .gray
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        return label
    }()
    let descLabel:UILabel = {
    let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 4
        label.font = UIFont.preferredFont(forTextStyle: .body)
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
        addSubview(articleImageView)
        addSubview(headlineLabel)
        addSubview(sourceName)
//        addSubview(descLabel)
        setupConstraints()
    }
    func setupConstraints(){
//        myImageView.image = nil
        NSLayoutConstraint.activate([
            articleImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            articleImageView.widthAnchor.constraint(equalToConstant: 70),
            articleImageView.heightAnchor.constraint(equalToConstant: 70),
            articleImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            articleImageView.topAnchor.constraint(equalTo: topAnchor,constant: 5)
        ])
        NSLayoutConstraint.activate([
            headlineLabel.trailingAnchor.constraint(equalTo: articleImageView.leadingAnchor,constant: -5),
            headlineLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 5),
            headlineLabel.topAnchor.constraint(equalTo: topAnchor,constant: 5)

        ])
//        NSLayoutConstraint.activate([
//            descLabel.trailingAnchor.constraint(equalTo: articleImageView.trailingAnchor),
////            descLabel.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor),
//            descLabel.leadingAnchor.constraint(equalTo: leadingAnchor)
////            descLabel.bottomAnchor.constraint(equalTo: sourceName.topAnchor)
//        ])
        NSLayoutConstraint.activate([
            sourceName.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor,constant: 2),
            sourceName.bottomAnchor.constraint(equalTo: bottomAnchor),
            sourceName.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 5),
            sourceName.trailingAnchor.constraint(equalTo: articleImageView.leadingAnchor)
        ])
    }
    // MARK: - Config
    public func configure(imgURL:URL,title:String, souceName:String?, description:String){
        headlineLabel.text = title
        if let source = souceName{
            sourceName.text = source
            print(source)
        }
            else{
            sourceName.text = "Not working"
        }
        descLabel.text = description
        
        
        load(from: imgURL) { data in
            guard let cellImage = UIImage(data: data) else{return}
            DispatchQueue.main.async {
                self.articleImageView.image = cellImage
            }
        }
    }
    // WHY
    func load(from url: URL, completion: @escaping (Data)->()) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
//                if let image = UIImage(data: data) {
//                    DispatchQueue.main.async {
//                        self?.image = image
//                    }
//                }
                completion(data)
            }
        }
    }
}

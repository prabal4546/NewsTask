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
        label.font = UIFont.preferredFont(forTextStyle: .caption2)
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
        backgroundColor = .clear
        layer.masksToBounds = false
        layer.shadowOpacity = 0.23
        layer.shadowRadius = 4
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowColor = UIColor.black.cgColor
        
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
        addSubview(descLabel)
        setupConstraints()
    }
    func setupConstraints(){
        //        myImageView.image = nil
        NSLayoutConstraint.activate([
            articleImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            articleImageView.heightAnchor.constraint(equalToConstant: 70),
            articleImageView.widthAnchor.constraint(equalTo: articleImageView.heightAnchor,multiplier: 16/9),
            //            articleImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            articleImageView.topAnchor.constraint(equalTo: topAnchor,constant: 5)
        ])
        NSLayoutConstraint.activate([
            headlineLabel.trailingAnchor.constraint(equalTo: articleImageView.leadingAnchor,constant: -5),
            headlineLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 5),
            headlineLabel.topAnchor.constraint(equalTo: topAnchor,constant: 5)
            
        ])
        
        NSLayoutConstraint.activate([
            descLabel.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor,constant: 2),
            descLabel.bottomAnchor.constraint(equalTo: sourceName.topAnchor),
            descLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 5),
            descLabel.trailingAnchor.constraint(equalTo: articleImageView.leadingAnchor)
        ])
        NSLayoutConstraint.activate([
            sourceName.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
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
        
            // FIX-ME: COCAPODS
        load(from: imgURL) { data in
            guard let cellImage = UIImage(data: data) else{return}
            DispatchQueue.main.async {
                self.articleImageView.image = cellImage
            }
        }
    }
    func load(from url: URL, completion: @escaping (Data)->()) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                completion(data)
            }
        }
    }
}

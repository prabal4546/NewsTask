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
     let myImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
         imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let myLabel:UILabel = {
    let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    // MARK: - ViewLifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize = contentView.frame.size.height - 6
//        myImageView.frame = CGRect(x: contentView.frame.size.width-imageSize, y: 3, width: imageSize, height: imageSize)
//        myLabel.frame = CGRect(x: 2, y: 0, width: contentView.frame.size.width - 10 - imageSize, height: contentView.frame.size.height)
        
    }
    
    func setupView(){
        contentView.addSubview(myImageView)
        contentView.addSubview(myLabel)
    }
    func setupConstraints(){
//        myImageView.image = nil
        NSLayoutConstraint.activate([
            myImageView.topAnchor.constraint(equalTo: topAnchor),
            myImageView.rightAnchor.constraint(equalTo: rightAnchor),
            myImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            myImageView.widthAnchor.constraint(equalTo:myImageView.heightAnchor)
        ])
        NSLayoutConstraint.activate([
            myLabel.leadingAnchor.constraint(equalTo: myImageView.trailingAnchor,constant: 5),
            myLabel.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -5),
            myLabel.topAnchor.constraint(equalTo: topAnchor,constant: 5),
            myLabel.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -5),

        ])
    }
    
    public func configure(imgURL:URL,text:String){
        var cellImage:UIImage = UIImage()
        
        load(from: imgURL) { data in
            guard let cellImage = UIImage(data: data) else{return}
            DispatchQueue.main.async {
                self.myImageView.image = cellImage
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

//
//  NewsfeedCell.swift
//  MireaApp
//
//  Created by Игорь Ходжгоров on 07.10.2022.
//
import Foundation
import UIKit
import SDWebImage

protocol FeedCellViewModel {
    var id: Int? { get }
    var name: String? { get }
    var image: String? { get }
}

class NewsfeedCell: UITableViewCell {
    
    static let reuseId = "NewsfeedCell"
    
    let postImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    } ()
    
    let postLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    } ()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(postImageView)
        contentView.addSubview(postLabel)
        postImageView.translatesAutoresizingMaskIntoConstraints = false
        postLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            postImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            postImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            postImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            postImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.66),
            postLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            postLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor),
            postLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            postLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func set(viewModel: FeedCellViewModel) {
        postLabel.text = viewModel.name
        
        guard let url = URL(string: viewModel.image!) else {return}
        postImageView.sd_setImage(with: url, completed: nil)
    }
}

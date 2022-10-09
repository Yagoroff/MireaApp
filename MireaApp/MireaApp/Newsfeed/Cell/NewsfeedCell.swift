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
    
    let postView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        return view
    } ()
    
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
        contentView.backgroundColor = UIColor.init(rgb: 0x2476a1)
        contentView.addSubview(postView)
        postView.addSubview(postImageView)
        postView.addSubview(postLabel)
        makeConstraints()
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

extension NewsfeedCell {
    private func makeConstraints() {
        postImageView.translatesAutoresizingMaskIntoConstraints = false
        postLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            postView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.9),
            postView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.9),
            postView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            postImageView.centerXAnchor.constraint(equalTo: postView.centerXAnchor),
            postImageView.topAnchor.constraint(equalTo: postView.topAnchor, constant: UIScreen.main.bounds.height/40),
            postImageView.widthAnchor.constraint(equalTo: postView.widthAnchor, multiplier: 0.9),
            postImageView.heightAnchor.constraint(equalTo: postView.heightAnchor, multiplier: 0.5),
            postLabel.centerXAnchor.constraint(equalTo: postView.centerXAnchor),
            postLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor),
            postLabel.bottomAnchor.constraint(equalTo: postView.bottomAnchor),
            postLabel.widthAnchor.constraint(equalTo: postView.widthAnchor, multiplier: 0.9),
        ])
    }
}

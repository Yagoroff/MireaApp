//
//  CellViewController.swift
//  MireaApp
//
//  Created by Игорь Ходжгоров on 11.10.2022.
//

import UIKit

class CellViewController: UIViewController {
    
    private lazy var postView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(rgb: 0x574af9)
        view.layer.cornerRadius = 5
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 2
        view.layer.shadowOpacity = 0.7
        view.layer.shadowOffset = CGSize(width: 5, height: 5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    private lazy var urlImage: String = ""
    
    private lazy var postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    } ()
    
    @objc private func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let imageViewController = ImageViewController()
        imageViewController.setImage(stringUrl: urlImage)
        navigationController?.present(imageViewController, animated: true)
    }
    
    private lazy var postLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setTapGestureRecognizer()
        addSubviews()
        makeConstraints()
    }
    
    func set(viewModel: FeedCellViewModel) {
        postLabel.text = viewModel.name
        
        guard let url = URL(string: viewModel.image!) else {return}
        urlImage = viewModel.image!
        postImageView.sd_setImage(with: url, completed: nil)
    }
}

extension CellViewController {
    private func setTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        postImageView.isUserInteractionEnabled = true
        postImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func addSubviews() {
        view.addSubview(postView)
        postView.addSubview(postImageView)
        postView.addSubview(postLabel)
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            postView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            postView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.6),
            postView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            postView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            postImageView.centerXAnchor.constraint(equalTo: postView.centerXAnchor),
            postImageView.topAnchor.constraint(equalTo: postView.topAnchor, constant: UIScreen.main.bounds.height/40),
            postImageView.heightAnchor.constraint(equalTo: postView.heightAnchor, multiplier: 0.5),
            postImageView.widthAnchor.constraint(equalTo: postView.widthAnchor, multiplier: 0.9),
            postLabel.centerXAnchor.constraint(equalTo: postView.centerXAnchor),
            postLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor),
            postLabel.bottomAnchor.constraint(equalTo: postView.bottomAnchor),
            postLabel.widthAnchor.constraint(equalTo: postView.widthAnchor, multiplier: 0.9),
        ])
    }
}

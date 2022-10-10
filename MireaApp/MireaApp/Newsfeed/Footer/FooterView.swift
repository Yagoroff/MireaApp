//
//  FooterView.swift
//  MireaApp
//
//  Created by Игорь Ходжгоров on 10.10.2022.
//

import Foundation
import UIKit

class FooterView: UIView {
    
    private var myLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    private var loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.hidesWhenStopped = true
        return loader
    } ()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(myLabel)
        addSubview(loader)
        NSLayoutConstraint.activate([
            myLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            myLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            myLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            loader.centerXAnchor.constraint(equalTo: centerXAnchor),
            loader.topAnchor.constraint(equalTo: myLabel.bottomAnchor, constant: 8)
        ])
    }
    
    func showLoader() {
        loader.startAnimating()
    }
    
    func setTitle(_ title: String?) {
        loader.stopAnimating()
        myLabel.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

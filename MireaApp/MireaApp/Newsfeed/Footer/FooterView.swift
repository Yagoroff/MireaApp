//
//  FooterView.swift
//  MireaApp
//
//  Created by Игорь Ходжгоров on 10.10.2022.
//

import Foundation
import UIKit

class FooterView: UIView {
    
    private let loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.hidesWhenStopped = true
        return loader
    } ()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(loader)
        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: centerXAnchor),
            loader.topAnchor.constraint(equalTo: bottomAnchor, constant: 15)
        ])
    }
    
    func showLoader() {
        loader.startAnimating()
    }
    
    func hideLoader() {
        loader.stopAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

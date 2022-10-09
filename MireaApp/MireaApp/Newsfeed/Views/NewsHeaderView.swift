//
//  HeaderNewsfeedView.swift
//  MireaApp
//
//  Created by Игорь Ходжгоров on 08.10.2022.
//

import UIKit

class NewsHeaderView: UIView {
    
    private let newsTitle: UILabel = {
        let label = UILabel()
        label.text = "Новости МИРЭА"
        label.textAlignment = .center
        label.font = UIFont(name: label.font.fontName, size: 30)
        label.textColor = UIColor.white
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.init(rgb: 0x2476a1)
        addSubview(newsTitle)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        newsTitle.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

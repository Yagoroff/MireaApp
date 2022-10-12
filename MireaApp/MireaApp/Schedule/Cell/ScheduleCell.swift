//
//  ScheduleCollectionViewCell.swift
//  MireaApp
//
//  Created by Игорь Ходжгоров on 10.10.2022.
//

import UIKit

class ScheduleCell: UICollectionViewCell {
    
    static let reuseId = "ScheduleCell"
    
    private let DICTWEEKS = [1: "Понедельник", 2: "Вторник", 3: "Среда", 4: "Четверг", 5: "Пятница", 6: "Суббота"]
    
    private lazy var cardView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(rgb: 0x574af9)
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 3
        view.layer.shadowOpacity = 0.7
        view.layer.shadowOffset = CGSize(width: 4, height:4)
        return view
    } ()
    
    private lazy var labelForLocation: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    } ()
    
    private lazy var labelForSubject: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        return label
    } ()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(cardView)
        cardView.addSubview(labelForLocation)
        cardView.addSubview(labelForSubject)
        makeConstraints()
    }
    
    private func makeConstraints() {
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UIScreen.main.bounds.width / 30),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -UIScreen.main.bounds.width / 30),
            labelForLocation.topAnchor.constraint(equalTo: cardView.topAnchor),
            labelForLocation.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 15),
            labelForLocation.widthAnchor.constraint(equalTo: cardView.widthAnchor, multiplier: 0.45),
            labelForLocation.heightAnchor.constraint(equalTo: cardView.heightAnchor),
            labelForSubject.topAnchor.constraint(equalTo: cardView.topAnchor),
            labelForSubject.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -15),
            labelForSubject.widthAnchor.constraint(equalTo: cardView.widthAnchor, multiplier: 0.45),
            labelForSubject.heightAnchor.constraint(equalTo: cardView.heightAnchor)
        ])
    }
    
    func configureLabelForLocation(number: Int, wdNum: Int, strWeeks: String, room: String) {
        labelForLocation.text = (DICTWEEKS[wdNum] ?? "ERROR") + ": \(number) парой в кабинете \(room).\nНедели: \(strWeeks)"
    }
    
    func configureWeekLabelForLocation(number: Int, wdNum: Int, room: String) {
        labelForLocation.text = (DICTWEEKS[wdNum] ?? "ERROR") + ": \(number) парой в кабинете \(room)."
    }
    
    func configureLabelForSubject(name: String, type: String, group: String) {
        labelForSubject.text = "\(name) \(type).\nГруппа: \(group)"
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

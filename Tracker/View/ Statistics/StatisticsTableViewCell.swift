//
//  StatisticsTableViewCell.swift
//  Tracker
//
//  Created by Dosh on 27.04.2024.
//

import UIKit

final class StatisticsTableViewCell: UITableViewCell {
    static let identifier = "cell"
    
    private lazy var viewGradient: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        
        return view
    }()
    
    private lazy var view: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        view.backgroundColor = .ypWhite
        
        return view
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.textAlignment = .left
        label.text = "0"
        
        return label
    }()
    
    private lazy var statisticTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .left
        
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.backgroundColor = .ypWhite
        setConstraints()
        setGradient()
    }
    
    func set(count: Int, title: String) {
        countLabel.text = String(count)
        statisticTitle.text = title
    }
    
    private func setGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = viewGradient.bounds
        gradientLayer.colors = [
            UIColor.red.cgColor,
            UIColor.orange.cgColor,
            UIColor.yellow.cgColor,
            UIColor.green.cgColor,
            UIColor.blue.cgColor,
            UIColor.purple.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        viewGradient.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setConstraints() {
        contentView.addSubview(viewGradient)
        viewGradient.addSubview(view)
        
        [statisticTitle,
         countLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            viewGradient.topAnchor.constraint(equalTo: contentView.topAnchor),
            viewGradient.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            viewGradient.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            viewGradient.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            view.topAnchor.constraint(equalTo: viewGradient.topAnchor, constant: 0.5),
            view.bottomAnchor.constraint(equalTo: viewGradient.bottomAnchor, constant: -0.5),
            view.leadingAnchor.constraint(equalTo: viewGradient.leadingAnchor, constant: 0.5),
            view.trailingAnchor.constraint(equalTo: viewGradient.trailingAnchor, constant: -0.5),
            
            countLabel.leadingAnchor.constraint(equalTo: viewGradient.leadingAnchor, constant: 12),
            countLabel.topAnchor.constraint(equalTo: viewGradient.topAnchor, constant: 12),
            countLabel.trailingAnchor.constraint(equalTo: viewGradient.trailingAnchor, constant: -12),
            
            statisticTitle.topAnchor.constraint(equalTo: countLabel.bottomAnchor, constant: 7),
            statisticTitle.leadingAnchor.constraint(equalTo: viewGradient.leadingAnchor, constant: 12),
            statisticTitle.trailingAnchor.constraint(equalTo: viewGradient.trailingAnchor, constant: -12),
        ])
    }
}



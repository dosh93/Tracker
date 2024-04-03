//
//  TrackerCollectionViewHeader.swift
//  Tracker
//
//  Created by Dosh on 31.03.2024.
//

import UIKit


final class TrackerCollectionViewHeader: UICollectionReusableView {
    
    static let identifier = "header"
    
    let headerLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initHeaderLabel()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initHeaderLabel() {
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.textColor = .ypBlack
        headerLabel.font = .systemFont(ofSize: 19, weight: .bold)
        addSubview(headerLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            headerLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            headerLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28)
        ])
    }
    
}


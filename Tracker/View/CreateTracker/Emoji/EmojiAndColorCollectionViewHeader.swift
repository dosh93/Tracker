//
//  EmojiCollectionViewHeader.swift
//  Tracker
//
//  Created by Dosh on 04.04.2024.
//

import UIKit

final class EmojiAndColorCollectionViewHeader: UICollectionReusableView {
    
    static let identifier = "header"
    
    let headerLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .ypBlack
        view.font = .systemFont(ofSize: 19, weight: .bold)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        addSubview(headerLabel)
        
        NSLayoutConstraint.activate([
            headerLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            headerLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        ])
    }
    
}

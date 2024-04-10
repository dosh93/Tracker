//
//  ColorCollectionViewCell.swift
//  Tracker
//
//  Created by Dosh on 05.04.2024.
//

import UIKit

final class ColorCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ColorCell"
    
    let customView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(customView)
        customView.layer.cornerRadius = 6
        customView.layer.masksToBounds = true
        customView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            customView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            customView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            customView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            customView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCell(color: UIColor, isSelect: Bool) {
        customView.backgroundColor = color
        if isSelect {
            self.layer.borderWidth = 3
            self.layer.borderColor = color.withAlphaComponent(0.3).cgColor
            self.layer.cornerRadius = 8
        } else {
            self.layer.borderWidth = 0
            self.layer.borderColor = nil
        }
    }
    
}

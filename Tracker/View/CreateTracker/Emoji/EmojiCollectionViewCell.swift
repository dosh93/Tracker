//
//  EmojiCollectionViewCell.swift
//  Tracker
//
//  Created by Dosh on 04.04.2024.
//

import UIKit

final class EmojiCollectionViewCell: UICollectionViewCell {
    static let identifier = "EmojiCell"
    
    let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 32)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCell(emoji: String, isSelect: Bool){
        label.text = emoji
        if isSelect {
            contentView.backgroundColor = .ypBackground
        } else {
            contentView.backgroundColor = .clear
        }
    }
    
}

//
//  SettingActionCell.swift
//  Tracker
//
//  Created by Dosh on 02.04.2024.
//

import UIKit

final class SettingActionCell: UITableViewCell {
    static let identifer = "cell"
    
    private let chevronUiImage = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        initChevronUiImage()
        initDetailLabel()
        setupConstraints()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initChevronUiImage() {
        chevronUiImage.translatesAutoresizingMaskIntoConstraints = false
        chevronUiImage.image = UIImage(named: "Chevron")
        contentView.addSubview(chevronUiImage)
    }
    
    private func initDetailLabel() {
        self.detailTextLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        self.detailTextLabel?.textColor = .ypGray
    }
    
    private func setupConstraints() {
        let heightCell = contentView.heightAnchor.constraint(equalToConstant: 75)
        heightCell.priority = .defaultHigh
        NSLayoutConstraint.activate([
            heightCell,
            
            chevronUiImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            chevronUiImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}

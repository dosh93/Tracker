//
//  SettingActionCell.swift
//  Tracker
//
//  Created by Dosh on 02.04.2024.
//

import UIKit

final class SettingActionCell: UITableViewCell {
    static let identifer = "cell"
    
    private let chevronUiImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "Chevron")
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(chevronUiImage)
        
        initDetailLabel()
        setupConstraints()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

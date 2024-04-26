//
//  CategoryTableViewCell.swift
//  Tracker
//
//  Created by Dosh on 15.04.2024.
//

import UIKit

final class CategoryTableViewCell: UITableViewCell {
    static let identifer = "cell"
    
    private let selecteImage = UIImageView(image: UIImage(named: "Done"))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .ypBackground
        initSelecteImage()
        setupConstraints()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initSelecteImage() {
        selecteImage.translatesAutoresizingMaskIntoConstraints = false
        selecteImage.isHidden = true
        contentView.addSubview(selecteImage)
    }
    
    private func setupConstraints() {
        let heightCell = contentView.heightAnchor.constraint(equalToConstant: 75)
        heightCell.priority = .defaultHigh
        NSLayoutConstraint.activate([
            heightCell,
            selecteImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            selecteImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    func setSelected(_ isSelected: Bool) {
        selecteImage.isHidden = !isSelected
    }
}

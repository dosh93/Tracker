//
//  WeekdayCell.swift
//  Tracker
//
//  Created by Dosh on 03.04.2024.
//

import UIKit

final class WeekdayCell: UITableViewCell {
    static let identifer = "cell"
    
    let selecteSwith = UISwitch()
    var switchChanged: ((Bool, Weekday) -> Void)?
    var representedDay: Weekday?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .ypBackground
        initSelecteSwith()
        setupConstraints()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initSelecteSwith() {
        selecteSwith.translatesAutoresizingMaskIntoConstraints = false
        selecteSwith.onTintColor = .ypBlue
        selecteSwith.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        contentView.addSubview(selecteSwith)
    }
    
    private func setupConstraints() {
        let heightCell = contentView.heightAnchor.constraint(equalToConstant: 75)
        heightCell.priority = .defaultHigh
        NSLayoutConstraint.activate([
            heightCell,
            
            selecteSwith.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            selecteSwith.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    @objc private func switchValueChanged(_ sender: UISwitch) {
        guard let day = self.representedDay else { return }
        switchChanged?(sender.isOn, day)
    }
}

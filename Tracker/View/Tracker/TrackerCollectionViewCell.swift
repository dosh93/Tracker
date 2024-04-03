//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Dosh on 31.03.2024.
//

import UIKit

final class TrackerCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TrackersCell"
    
    weak var delegate: TrackerCellDelegate?
    private var id: UUID?
    private var indexPath: IndexPath?
    
    private let trackerView = UIView()
    private let emojiLabel = UILabel()
    private let emojiView = UIView()
    private let nameLabel = UILabel()
    
    private let actionView = UIView()
    private let countDayLabel = UILabel()
    private let trackButton = UIButton(type: .custom)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initMainView()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initMainView() {
        initTrackerView()
        initActionView()
        
        contentView.addSubview(trackerView)
        contentView.addSubview(actionView)
    }
    
    private func initTrackerView() {
        trackerView.translatesAutoresizingMaskIntoConstraints = false
        trackerView.layer.cornerRadius = 16
        trackerView.layer.masksToBounds = true
        
        initEmoji()
        initNameLabel()
        
        trackerView.addSubview(emojiView)
        trackerView.addSubview(nameLabel)
    }
    
    private func initEmoji() {
        emojiView.translatesAutoresizingMaskIntoConstraints = false
        emojiView.backgroundColor = .ypBackground
        emojiView.layer.masksToBounds = true
        emojiView.layer.cornerRadius = 12
        
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        emojiLabel.textAlignment = .center
        emojiLabel.font = .systemFont(ofSize: 12)
        emojiView.addSubview(emojiLabel)
    }
    
    private func initNameLabel() {
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textColor = .ypWhite
        nameLabel.numberOfLines = 2
        nameLabel.textAlignment = .left
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.font = .systemFont(ofSize: 12, weight: .medium)
    }
    
    private func initActionView() {
        actionView.translatesAutoresizingMaskIntoConstraints = false
        actionView.backgroundColor = .ypWhite
        actionView.layer.cornerRadius = 16
        actionView.layer.masksToBounds = true
        
        initDayLabel()
        initTrackButton()
        
        actionView.addSubview(countDayLabel)
        actionView.addSubview(trackButton)
    }
    
    
    private func initDayLabel() {
        countDayLabel.translatesAutoresizingMaskIntoConstraints = false
        countDayLabel.font = .systemFont(ofSize: 12, weight: .medium)
        countDayLabel.textColor = .ypBlack
    }
    
    private func initTrackButton() {
        trackButton.translatesAutoresizingMaskIntoConstraints = false
        trackButton.imageEdgeInsets = UIEdgeInsets(top: 11, left: 11, bottom: 11, right: 11)
        trackButton.layer.masksToBounds = true
        trackButton.layer.cornerRadius = 16
        trackButton.tintColor = .ypWhite
        trackButton.addTarget(self, action: #selector(trackButtonTapped), for: .touchUpInside)
    }
    
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            trackerView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            trackerView.widthAnchor.constraint(equalToConstant: 167),
            trackerView.heightAnchor.constraint(equalToConstant: 90),
            
            emojiView.topAnchor.constraint(equalTo: trackerView.topAnchor, constant: 12),
            emojiView.leadingAnchor.constraint(equalTo: trackerView.leadingAnchor, constant: 12),
            emojiView.heightAnchor.constraint(equalToConstant: 24),
            emojiView.widthAnchor.constraint(equalToConstant: 24),
            emojiLabel.centerXAnchor.constraint(equalTo: emojiView.safeAreaLayoutGuide.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiView.safeAreaLayoutGuide.centerYAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: emojiView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: trackerView.leadingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: trackerView.trailingAnchor, constant: -12),
            nameLabel.bottomAnchor.constraint(equalTo: trackerView.bottomAnchor, constant: -12),
            
            actionView.topAnchor.constraint(equalTo: trackerView.bottomAnchor),
            actionView.widthAnchor.constraint(equalToConstant: 167),
            actionView.heightAnchor.constraint(equalToConstant: 58),
            
            countDayLabel.topAnchor.constraint(equalTo: actionView.topAnchor, constant: 8),
            countDayLabel.leadingAnchor.constraint(equalTo: actionView.leadingAnchor, constant: 12),
            countDayLabel.trailingAnchor.constraint(equalTo: trackButton.leadingAnchor, constant: -8),
            countDayLabel.bottomAnchor.constraint(equalTo: actionView.bottomAnchor, constant: -16),
            
            trackButton.topAnchor.constraint(equalTo: actionView.topAnchor, constant: 8),
            trackButton.trailingAnchor.constraint(equalTo: actionView.trailingAnchor, constant: -12),
            trackButton.widthAnchor.constraint(equalToConstant: 34),
            trackButton.heightAnchor.constraint(equalToConstant: 34),
        ])
    }
    
    func initByData(id: UUID, indexPath: IndexPath, emoji: String, name: String, color: UIColor, countCompleted: Int, isCompleted: Bool, isEnabled: Bool) {
        self.id = id
        self.indexPath = indexPath
        
        emojiLabel.text = emoji
        nameLabel.text = name
        trackerView.backgroundColor = color
        trackButton.backgroundColor = color
        countDayLabel.text = getCounDayStr(from: countCompleted)
        setImageTrackButton(isCompleted: isCompleted, isEnabled: isEnabled)
    }

    func getCounDayStr(from count: Int) -> String {
        let lastDigit = count % 10
        let lastTwoDigits = count % 100
        
        if lastTwoDigits >= 11 && lastTwoDigits <= 14 {
            return "\(count) дней"
        } else if lastDigit == 1 {
            return "\(count) день"
        } else if lastDigit >= 2 && lastDigit <= 4 {
            return "\(count) дня"
        } else {
            return "\(count) дней"
        }
    }
    
    func setImageTrackButton(isCompleted: Bool, isEnabled: Bool) {
        let imageName = isCompleted ? "Done" : "PlusTask"
        if let image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate) {
            trackButton.setImage(image, for: .normal)
        }
        
        trackButton.isEnabled = isEnabled
    }
    
    @objc private func trackButtonTapped() {
        guard let id = self.id else { return }
        guard let indexPath = self.indexPath else { return }
        delegate?.trackerCompleted(for: id, at: indexPath)
    }
}

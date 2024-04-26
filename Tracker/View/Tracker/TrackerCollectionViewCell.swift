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
    var id: UUID?
    var indexPath: IndexPath?
    
    let trackerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    private let emojiLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textAlignment = .center
        view.font = .systemFont(ofSize: 12)
        return view
    }()
    
    private let emojiView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypBackground
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 12
        return view
    }()
    
    private let nameLabel: UILabel = {
        let view = UILabel()
        view.textColor = .ypWhite
        view.numberOfLines = 2
        view.textAlignment = .left
        view.lineBreakMode = .byWordWrapping
        view.font = .systemFont(ofSize: 12, weight: .medium)
        return view
    }()
    
    let actionView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypWhite
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    private let countDayLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 12, weight: .medium)
        view.textColor = .ypBlack
        return view
    }()
    
    private let trackButton: UIButton = {
        let view = UIButton(type: .custom)
        view.imageEdgeInsets = UIEdgeInsets(top: 11, left: 11, bottom: 11, right: 11)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 16
        view.tintColor = .ypWhite
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        trackButton.addTarget(self, action: #selector(trackButtonTapped), for: .touchUpInside)
        
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        [trackerView, actionView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        [emojiView, nameLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            trackerView.addSubview($0)
        }
        
        emojiView.addSubview(emojiLabel)
        
        [countDayLabel, trackButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            actionView.addSubview($0)
        }
        
        
        NSLayoutConstraint.activate([
            trackerView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            trackerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            trackerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
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
            actionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            actionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
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
    
    func update(emoji: String?, name: String?, color: UIColor?, countCompleted: Int, isCompleted: Bool, isEnabled: Bool) {
        emojiLabel.text = emoji
        nameLabel.text = name
        trackerView.backgroundColor = color
        trackButton.backgroundColor = color
        countDayLabel.text = getCounDayStr(from: countCompleted)
        setImageTrackButton(isCompleted: isCompleted, isEnabled: isEnabled)
    }

    private func getCounDayStr(from count: Int) -> String {
        return String.localizedStringWithFormat(NSLocalizedString("numberOfTracker", comment: "Количество затреканный дней"), count)
    }
    
    private func setImageTrackButton(isCompleted: Bool, isEnabled: Bool) {
        let imageName = isCompleted ? "Done" : "PlusTask"
        if let image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate) {
            if isCompleted {
                trackButton.backgroundColor = trackButton.backgroundColor?.withAlphaComponent(0.3)
            }
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

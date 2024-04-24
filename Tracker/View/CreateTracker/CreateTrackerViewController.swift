//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by Dosh on 01.04.2024.
//

import UIKit

final class CreateTrackerViewController: UIViewController {
    
    weak var delegate: CreateTrackerViewControllerDelegate?
    private let headerLabel: UILabel = {
        let view = UILabel()
        view.text = NSLocalizedString("header.createTracker", comment: "Заголовок создание трекера")
        view.textColor = .ypBlack
        view.textAlignment = .center
        view.font = .systemFont(ofSize: 16, weight: .medium)
        return view
    }()
    
    private let regularActionButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("button.habit", comment: "Кнопка создание привычки"), for: .normal)
        button.backgroundColor = .ypBlack
        button.setTitleColor(.ypWhite, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        return button
    }()
    
    private let unregularActionButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("button.irregularEvents", comment: "Кнопка создание нерегулярного собития"), for: .normal)
        button.backgroundColor = .ypBlack
        button.setTitleColor(.ypWhite, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        return button
    }()
    
    private let stackButtonsView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 16
        view.distribution = .fillEqually
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        
        regularActionButton.addTarget(self, action: #selector(addRegularAction), for: .touchUpInside)
        unregularActionButton.addTarget(self, action: #selector(addUnregularAction), for: .touchUpInside)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        [headerLabel, stackButtonsView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        [regularActionButton, unregularActionButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            stackButtonsView.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            headerLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            stackButtonsView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            stackButtonsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            stackButtonsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            regularActionButton.heightAnchor.constraint(equalToConstant: 60),
            unregularActionButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc
    private func addRegularAction() {
        let viewController = ActionViewController(setting: SettingActionView(header: NSLocalizedString("header.habit", comment: "Заголовок создания привычки"), tableCount: 2, type: TypeView.regular))
        viewController.delegate = self
        present(viewController, animated: true)
    }
    
    @objc
    private func addUnregularAction() {
        let viewController = ActionViewController(setting: SettingActionView(header: NSLocalizedString("header.irregularEvents", comment: "Заголовок создания нерегулярного события"), tableCount: 1, type: TypeView.unregular))
        viewController.delegate = self
        present(viewController, animated: true)
    }
}

extension CreateTrackerViewController: CreateTrackerViewControllerDelegate {
    func createTracker(_ tracker: Tracker, _ category: String) {
        delegate?.createTracker(tracker, category)
    }
}

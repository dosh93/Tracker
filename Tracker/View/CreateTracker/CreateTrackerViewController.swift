//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by Dosh on 01.04.2024.
//

import UIKit

final class CreateTrackerViewController: UIViewController {
    
    weak var delegate: CreateTrackerViewControllerDelegate?
    private let headerLabel = UILabel()
    private let regularActionButton = UIButton()
    private let unregularActionButton = UIButton()
    private let stackButtonsView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        
        initHeaderLabel()
        initStackButtonView()
        initRegularActionButton()
        initUnregularActionButton()
        setupConstraints()
    }
    
    private func initHeaderLabel() {
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.text = "Создание трекера"
        headerLabel.textColor = .ypBlack
        headerLabel.textAlignment = .center
        headerLabel.font = .systemFont(ofSize: 16, weight: .medium)
        view.addSubview(headerLabel)
    }
    
    private func initStackButtonView() {
        stackButtonsView.axis = .vertical
        stackButtonsView.spacing = 16
        stackButtonsView.distribution = .fillEqually
        stackButtonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackButtonsView)
    }
    
    private func initRegularActionButton() {
        regularActionButton.translatesAutoresizingMaskIntoConstraints = false
        regularActionButton.setTitle("Привычка", for: .normal)
        regularActionButton.backgroundColor = .ypBlack
        regularActionButton.setTitleColor(.ypWhite, for: .normal)
        regularActionButton.layer.masksToBounds = true
        regularActionButton.layer.cornerRadius = 16
        regularActionButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        regularActionButton.addTarget(self, action: #selector(addRegularAction), for: .touchUpInside)
        stackButtonsView.addArrangedSubview(regularActionButton)
    }
    
    private func initUnregularActionButton() {
        unregularActionButton.translatesAutoresizingMaskIntoConstraints = false
        unregularActionButton.setTitle("Нерегулярные событие", for: .normal)
        unregularActionButton.backgroundColor = .ypBlack
        unregularActionButton.setTitleColor(.ypWhite, for: .normal)
        unregularActionButton.layer.masksToBounds = true
        unregularActionButton.layer.cornerRadius = 16
        unregularActionButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        unregularActionButton.addTarget(self, action: #selector(addUnregularAction), for: .touchUpInside)
        stackButtonsView.addArrangedSubview(unregularActionButton)
    }
    
    private func setupConstraints() {
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
        let viewController = RegularActionViewController()
        viewController.delegate = self
        present(viewController, animated: true)
    }
    
    @objc
    private func addUnregularAction() {
        let viewController = UnregularActionViewController()
        viewController.delegate = self
        present(viewController, animated: true)
    }
}

extension CreateTrackerViewController: CreateTrackerViewControllerDelegate {
    func createTracker(_ tracker: Tracker, _ category: String) {
        delegate?.createTracker(tracker, category)
    }
}

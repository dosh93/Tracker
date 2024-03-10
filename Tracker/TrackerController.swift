//
//  ViewController.swift
//  Tracker
//
//  Created by Dosh on 09.03.2024.
//

import UIKit

class TrackerController: UIViewController {
    
    private let yaBlackDayColor = UIColor(named: "YABlackDay")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        showPlaceholderIfNeeded()
        setupTitle()
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.tintColor = yaBlackDayColor
        let addTrackerImage = UIImage(named: "addTracker")?.withRenderingMode(.alwaysTemplate)

        let addButton = UIBarButtonItem(image: addTrackerImage, style: .plain, target: self, action: #selector(addTracker))
        self.navigationItem.leftBarButtonItem = addButton
    }
    
    private func setupTitle() {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(titleLabel)
        
        titleLabel.text = "Трекеры"
        titleLabel.textColor = yaBlackDayColor
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 1),
            titleLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
        ])
    
    }
    
    
    @objc private func addTracker() {
        print("Добавить трекер")
    }
    
    private func showPlaceholderIfNeeded() {
        let isListEmpty = true
        
        if isListEmpty {
            let placeholderView = makePlaceholderView()
            placeholderView.frame = self.view.bounds
            self.view.addSubview(placeholderView)
        }
    }
    
    private func makePlaceholderView() -> UIView {
        let placeholderView = UIView()
        placeholderView.backgroundColor = .white
        
        let placeholderImage = UIImageView(image: UIImage(named: "placeholder"))
        placeholderImage.contentMode = .center
        placeholderView.addSubview(placeholderImage)
        
        let placeholderLabel = UILabel()
        placeholderLabel.text = "Что будем отслеживать?"
        placeholderLabel.textColor = yaBlackDayColor
        placeholderLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        placeholderLabel.textAlignment = .center
        placeholderView.addSubview(placeholderLabel)
        
        placeholderImage.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            placeholderImage.centerXAnchor.constraint(equalTo: placeholderView.centerXAnchor),
            placeholderImage.centerYAnchor.constraint(equalTo: placeholderView.centerYAnchor),
            placeholderLabel.topAnchor.constraint(equalTo: placeholderImage.bottomAnchor, constant: 8),
            placeholderLabel.centerXAnchor.constraint(equalTo: placeholderView.centerXAnchor)
        ])
        
        return placeholderView
    }
}



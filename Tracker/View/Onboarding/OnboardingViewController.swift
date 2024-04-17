//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Dosh on 14.04.2024.
//

import UIKit

final class OnboardingViewController: UIViewController {
    
    private var label: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack.toLight()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var backgroundUIImage: UIImageView = {
        let uiImage = UIImageView()
        uiImage.translatesAutoresizingMaskIntoConstraints = false
        uiImage.contentMode = .scaleAspectFill
        return uiImage
    }()
    
    private var backgrouadName: String
    private var labelText: String
    
    init(backgrouadName: String, labelText: String) {
        self.backgrouadName = backgrouadName
        self.labelText = labelText
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundUIImage.image = UIImage(named: backgrouadName)
        label.text = labelText
        
        view.addSubview(backgroundUIImage)
        view.sendSubviewToBack(backgroundUIImage)
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            backgroundUIImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundUIImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            backgroundUIImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundUIImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundUIImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundUIImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -270),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

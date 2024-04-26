//
//  CreateCategoryViewController.swift
//  Tracker
//
//  Created by Dosh on 16.04.2024.
//

import UIKit

final class CreateCategoryViewController: UIViewController {
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.text = NSLocalizedString("header.newCategory", comment: "Заголовок новая категория")
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let field = UITextField()
        field.placeholder = NSLocalizedString("placeholder.input.newCategory", comment: "Плейсхолдер для новой категории")
        field.backgroundColor = .ypBackground
        field.layer.cornerRadius = 16
        field.layer.masksToBounds = true
        field.font = .systemFont(ofSize: 17, weight: .regular)
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: field.frame.height))
        field.leftViewMode = .always
        field.clearButtonMode = .whileEditing
        field.delegate = self
        return field
    }()
    
    private lazy var createCategroryButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("button.done", comment: "Кнопка готово"), for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .ypGray
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.isEnabled = false
        button.addTarget(self, action: #selector(createCategory), for: .touchUpInside)
        return button
    }()
    
    private var viewModel: CategoryViewModel?
    
    func initialize(viewModel: CategoryViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        setupConstraints()
    }
    
    private func setupConstraints() {
        [headerLabel, nameTextField, createCategroryButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            headerLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 24),
            nameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 75),
            
            createCategroryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            createCategroryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            createCategroryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            createCategroryButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    private func checkRequiredField() {
        let nameText = nameTextField.text ?? ""
        
        let isFormValid = !nameText.isEmpty
        
        disabledCreateButton(isDisabled: !isFormValid)
    }
    
    private func disabledCreateButton(isDisabled: Bool) {
        createCategroryButton.isEnabled = !isDisabled
        createCategroryButton.backgroundColor = isDisabled ? .ypGray: .ypBlack
    }
    
    @objc private func createCategory() {
        viewModel?.createCategory(nameTextField.text ?? "")
        self.dismiss(animated: true)
    }
}

extension CreateCategoryViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        checkRequiredField()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

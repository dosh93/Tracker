//
//  ReqularActionViewController.swift
//  Tracker
//
//  Created by Dosh on 01.04.2024.
//

import UIKit

final class UnregularActionViewController: UIViewController {
    
    weak var delegate: CreateTrackerViewControllerDelegate?
    private let headerLabel = UILabel()
    private let nameTextField = UITextField()
    private let errorLabel = UILabel()
    private let categoryTableView = UITableView(frame: .zero)
    
    private let stackButtonsView = UIStackView()
    private let createActionButton = UIButton()
    private let cancelButton = UIButton()
    private let currentCategory = "Важно"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        
        initHeaderLabel()
        initNameTextFiled()
        initErrorLabel()
        initCategoryTableView()
        initStackButtonsView()
        initCancelButton()
        initCreateActionButton()
        setupConstraints()
        
        setTapGesture()
    }
    
    private func setTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func initHeaderLabel() {
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.text = "Новое нерегулярное событие"
        headerLabel.textColor = .ypBlack
        headerLabel.textAlignment = .center
        headerLabel.font = .systemFont(ofSize: 16, weight: .medium)
        view.addSubview(headerLabel)
    }
    
    private func initNameTextFiled() {
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        nameTextField.placeholder = "Введите название трекера"
        nameTextField.backgroundColor = .ypBackground
        nameTextField.layer.cornerRadius = 16
        nameTextField.layer.masksToBounds = true
        nameTextField.font = .systemFont(ofSize: 17, weight: .regular)
        nameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: nameTextField.frame.height))
        nameTextField.leftViewMode = .always
        nameTextField.clearButtonMode = .whileEditing
        nameTextField.delegate = self
        view.addSubview(nameTextField)
    }
    
    private func initCategoryTableView() {
        categoryTableView.translatesAutoresizingMaskIntoConstraints = false
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        categoryTableView.backgroundColor = .ypBackground
        categoryTableView.layer.masksToBounds = true
        categoryTableView.layer.cornerRadius = 16
        categoryTableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        categoryTableView.register(SettingActionCell.self, forCellReuseIdentifier: SettingActionCell.identifer)
        view.addSubview(categoryTableView)
    }
    
    private func initErrorLabel() {
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.text = "Ограничение 38 символов"
        errorLabel.font = .systemFont(ofSize: 17, weight: .regular)
        errorLabel.textColor = .ypRed
        errorLabel.textAlignment = .center
        errorLabel.isHidden = true
        view.addSubview(errorLabel)
    }
    
    private func initStackButtonsView() {
        stackButtonsView.axis = .horizontal
        stackButtonsView.spacing = 8
        stackButtonsView.distribution = .fillEqually
        stackButtonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackButtonsView)
    }
    
    private func initCreateActionButton() {
        createActionButton.translatesAutoresizingMaskIntoConstraints = false
        createActionButton.setTitle("Создать", for: .normal)
        createActionButton.setTitleColor(.ypWhite, for: .normal)
        createActionButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        createActionButton.backgroundColor = .ypGray
        createActionButton.layer.cornerRadius = 16
        createActionButton.layer.masksToBounds = true
        createActionButton.isEnabled = false
        createActionButton.addTarget(self, action: #selector(createAction), for: .touchUpInside)
        stackButtonsView.addArrangedSubview(createActionButton)
    }
    
    private func initCancelButton() {
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitle("Отменить", for: .normal)
        cancelButton.setTitleColor(.ypRed, for: .normal)
        cancelButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        cancelButton.backgroundColor = .ypWhite
        cancelButton.layer.cornerRadius = 16
        cancelButton.layer.masksToBounds = true
        cancelButton.layer.borderColor = UIColor.ypRed.cgColor
        cancelButton.layer.borderWidth = 1
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        stackButtonsView.addArrangedSubview(cancelButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            headerLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 30),
            nameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 63),
            
            errorLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 8),
            errorLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            categoryTableView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            categoryTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            categoryTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            categoryTableView.heightAnchor.constraint(equalToConstant: 75),
            
            stackButtonsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackButtonsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            stackButtonsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            createActionButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc
    func cancelButtonTapped() {
        self.view.window?.rootViewController?.dismiss(animated: true)
    }
    
    @objc
    func createAction() {
        let nameText = nameTextField.text ?? ""
        let tracker = Tracker(id: UUID.init(), name: nameText, color: .ypColor1, emoji: "🏃", schedule: Weekday.allCases, isRegular: false)
        delegate?.createTracker(tracker, currentCategory)
    }
    
    func checkRequiredField() {
        let nameText = nameTextField.text ?? ""
        
        errorLabel.isHidden = nameText.count <= 38
        
        let isFormValid = !nameText.isEmpty && nameText.count <= 38 && !currentCategory.isEmpty
        
        disabledCreateButton(isDisabled: !isFormValid)
    }

    
    private func disabledCreateButton(isDisabled: Bool) {
        if (isDisabled) {
            createActionButton.isEnabled = false
            createActionButton.backgroundColor = .ypGray
        } else {
            createActionButton.isEnabled = true
            createActionButton.backgroundColor = .ypBlack
        }
    }
}

extension UnregularActionViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        checkRequiredField()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension UnregularActionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension UnregularActionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingActionCell.identifer, for: indexPath) as? SettingActionCell else {
            return UITableViewCell()
        }
        cell.textLabel?.text = "Категория"
        cell.detailTextLabel?.text = currentCategory
        cell.backgroundColor = .ypBackground
        return cell
    }
}

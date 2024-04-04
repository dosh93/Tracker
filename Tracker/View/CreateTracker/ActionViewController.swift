//
//  ActionViewController.swift
//  Tracker
//
//  Created by Dosh on 04.04.2024.
//

import UIKit

final class ActionViewController: UIViewController {
    
    weak var delegate: CreateTrackerViewControllerDelegate?
    
    private let headerLabel: UILabel = {
        let view = UILabel()
        view.textColor = .ypBlack
        view.textAlignment = .center
        view.font = .systemFont(ofSize: 16, weight: .medium)
        return view
    }()
    
    private let nameTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "Введите название трекера"
        view.backgroundColor = .ypBackground
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.font = .systemFont(ofSize: 17, weight: .regular)
        view.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: view.frame.height))
        view.leftViewMode = .always
        view.clearButtonMode = .whileEditing
        return view
    }()
    
    private let errorLabel: UILabel = {
        let view = UILabel()
        view.text = "Ограничение 38 символов"
        view.font = .systemFont(ofSize: 17, weight: .regular)
        view.textColor = .ypRed
        view.textAlignment = .center
        view.isHidden = true
        return view
    }()
    
    private let categoryAndSheduleTableView: UITableView = {
        let view = UITableView(frame: .zero)
        view.backgroundColor = .ypBackground
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.register(SettingActionCell.self, forCellReuseIdentifier: SettingActionCell.identifer)
        view.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return view
    }()
    
    private let stackButtonsView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 8
        view.distribution = .fillEqually
        return view
    }()
    
    private let createActionButton: UIButton = {
        let view = UIButton()
        view.setTitle("Создать", for: .normal)
        view.setTitleColor(.ypWhite, for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        view.backgroundColor = .ypGray
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.isEnabled = false
        return view
    }()
    
    private let cancelButton: UIButton = {
        let view = UIButton()
        view.setTitle("Отменить", for: .normal)
        view.setTitleColor(.ypRed, for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        view.backgroundColor = .ypWhite
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.layer.borderColor = UIColor.ypRed.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private var currentCategory = "Регулярно важно"
    private var currentShedule: [Weekday] = []
    
    private let setting: SettingActionView
    
    init(setting: SettingActionView) {
        self.setting = setting
        headerLabel.text = setting.header
        
        if setting.type == TypeView.unregular {
            currentShedule = Weekday.allCases
            currentCategory = "Важно"
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        
        categoryAndSheduleTableView.delegate = self
        categoryAndSheduleTableView.dataSource = self
        nameTextField.delegate = self
        
        createActionButton.addTarget(self, action: #selector(createAction), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        setupConstraints()
        
        setTapGesture()
    }
    
    private func setTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func setupConstraints() {
        [headerLabel, nameTextField, errorLabel, stackButtonsView, categoryAndSheduleTableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        [cancelButton, createActionButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            stackButtonsView.addArrangedSubview($0)
        }
        
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            headerLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 30),
            nameTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 63),
            
            errorLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 8),
            errorLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            categoryAndSheduleTableView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            categoryAndSheduleTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            categoryAndSheduleTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            categoryAndSheduleTableView.heightAnchor.constraint(equalToConstant: CGFloat(75 * setting.tableCount)),
            
            stackButtonsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackButtonsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            stackButtonsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            createActionButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc
    private func cancelButtonTapped() {
        self.view.window?.rootViewController?.dismiss(animated: true)
    }
    
    @objc
    private func createAction() {
        let nameText = nameTextField.text ?? ""
        let tracker = Tracker(id: UUID.init(), name: nameText, color: .ypColor1, emoji: "🏃", schedule: currentShedule, isRegular: setting.type == TypeView.regular)
        delegate?.createTracker(tracker, currentCategory)
    }
    
    private func checkRequiredField() {
        let nameText = nameTextField.text ?? ""
        
        errorLabel.isHidden = nameText.count <= 38
        
        let isFormValid = !nameText.isEmpty && nameText.count <= 38 && !currentCategory.isEmpty && !currentShedule.isEmpty
        
        disabledCreateButton(isDisabled: !isFormValid)
    }

    
    private func disabledCreateButton(isDisabled: Bool) {
        createActionButton.isEnabled = !isDisabled
        createActionButton.backgroundColor = isDisabled ? .ypGray: .ypBlack
    }
}

extension ActionViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        checkRequiredField()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension ActionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if  indexPath.item == 0 {
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            let viewController = SheduleViewController()
            viewController.delegate = self
            present(viewController, animated: true)
        }
    }
}

extension ActionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        setting.tableCount
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingActionCell.identifer, for: indexPath) as? SettingActionCell else {
            return UITableViewCell()
        }
        if indexPath.item == 0 {
            cell.textLabel?.text = "Категория"
            cell.detailTextLabel?.text = currentCategory
        } else {
            cell.textLabel?.text = "Расписание"
            let shorName = currentShedule.map { $0.getShortDayName }
            if shorName.count == 7 {
                cell.detailTextLabel?.text = "Каждый день"
            } else if !shorName.isEmpty {
                cell.detailTextLabel?.text = shorName.joined(separator: ", ")
            } else {
                cell.detailTextLabel?.text = nil
            }
        }
        
        cell.backgroundColor = .ypBackground
        return cell
    }
}

extension ActionViewController: SheduleViewControllerDelegate {
    func addShedule(_ shedule: [Weekday]) {
        currentShedule = shedule
        checkRequiredField()
        categoryAndSheduleTableView.reloadData()
    }
}

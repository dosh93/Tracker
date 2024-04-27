//
//  ActionViewController.swift
//  Tracker
//
//  Created by Dosh on 04.04.2024.
//

import UIKit

final class ActionViewController: UIViewController {
    
    weak var createDelegate: CreateTrackerViewControllerDelegate?
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .ypWhite
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let headerLabel: UILabel = {
        let view = UILabel()
        view.textColor = .ypBlack
        view.textAlignment = .center
        view.font = .systemFont(ofSize: 16, weight: .medium)
        return view
    }()
    
    private let countDayLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.isHidden = true
        return label
    }()
    
    private let nameTextField: UITextField = {
        let view = UITextField()
        view.placeholder = NSLocalizedString("placeholder.input.nameTracker", comment: "Плейсзолдре имя трекера")
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
        view.text = NSLocalizedString("error.limitSymbol", comment: "Ошибка ограничения символов")
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
    
    private let emojiAndColorCollictionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return view
    }()
    
    private var emojiAndColorCollictionManager = EmojiAndColorCollectionView(emoji: nil, color: nil)
    
    private let stackButtonsView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 8
        view.distribution = .fillEqually
        return view
    }()
    
    private let createActionButton: UIButton = {
        let view = UIButton()
        view.setTitle(NSLocalizedString("button.create", comment: "Кнопка создать"), for: .normal)
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
        view.setTitle(NSLocalizedString("button.cancel", comment: "Кнопка создать"), for: .normal)
        view.setTitleColor(.ypRed, for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        view.backgroundColor = .ypWhite
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.layer.borderColor = UIColor.ypRed.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    private var currentCategory = ""
    private var currentShedule: [Weekday] = []
    private var emoji: String = ""
    private var color: UIColor? = nil
    
    private let setting: SettingActionView
    
    init(setting: SettingActionView) {
        self.setting = setting
        headerLabel.text = setting.header
        
        if setting.type == TypeView.unregular {
            currentShedule = Weekday.allCases
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        
        if let tracker = setting.tracker {
            emoji = tracker.emoji
            color = tracker.color
            currentShedule = tracker.schedule
            nameTextField.text = tracker.name
            emojiAndColorCollictionManager = EmojiAndColorCollectionView(emoji: emoji, color: color)
            createActionButton.setTitle(NSLocalizedString("button.save", comment: "Кнопка сохранить"), for: .normal)
        }
        
        if let category = setting.category {
            currentCategory = category
        }
        
        if let countCompleted = setting.countCompleted {
            countDayLabel.isHidden = false
            countDayLabel.text = String.localizedStringWithFormat(NSLocalizedString("numberOfTracker", comment: "Количество затреканный дней"), countCompleted)
        }
        
        categoryAndSheduleTableView.delegate = self
        categoryAndSheduleTableView.dataSource = self
        nameTextField.delegate = self
        
        registerEmojiCollection()
        
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
    
    private func registerEmojiCollection() {
        emojiAndColorCollictionManager.delegate = self
        emojiAndColorCollictionView.delegate = emojiAndColorCollictionManager
        emojiAndColorCollictionView.dataSource = emojiAndColorCollictionManager
        
        emojiAndColorCollictionView.register(EmojiCollectionViewCell.self, forCellWithReuseIdentifier: EmojiCollectionViewCell.identifier)
        emojiAndColorCollictionView.register(ColorCollectionViewCell.self, forCellWithReuseIdentifier: ColorCollectionViewCell.identifier)
        emojiAndColorCollictionView.register(EmojiAndColorCollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: EmojiAndColorCollectionViewHeader.identifier)

    }
    
    private func setupConstraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        [headerLabel, countDayLabel, nameTextField, errorLabel, categoryAndSheduleTableView, emojiAndColorCollictionView, stackButtonsView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview($0)
        }
        
        [cancelButton, createActionButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            stackButtonsView.addArrangedSubview($0)
        }
        
        stackView.setCustomSpacing(14, after: headerLabel)
        stackView.setCustomSpacing(40, after: countDayLabel)
        stackView.setCustomSpacing(24, after: nameTextField)
        stackView.setCustomSpacing(34, after: categoryAndSheduleTableView)
        stackView.setCustomSpacing(24, after: emojiAndColorCollictionView)
        
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            stackButtonsView.heightAnchor.constraint(equalToConstant: 60),
            categoryAndSheduleTableView.heightAnchor.constraint(equalToConstant: CGFloat(75 * setting.tableCount)),
            
            headerLabel.heightAnchor.constraint(equalToConstant: 70),
            nameTextField.heightAnchor.constraint(equalToConstant: 75),
            emojiAndColorCollictionView.heightAnchor.constraint(equalToConstant: 444)
        ])
    }
    
    @objc
    private func cancelButtonTapped() {
        self.view.window?.rootViewController?.dismiss(animated: true)
    }
    
    @objc
    private func createAction() {
        let nameText = nameTextField.text ?? ""
        let uuid = setting.tracker?.id ?? UUID.init()
        let tracker = Tracker(id: uuid, name: nameText, color: color ?? .ypColor1, emoji: emoji, schedule: currentShedule, isRegular: setting.type == TypeView.regular, isPinned: setting.tracker?.isPinned ?? false)
        createDelegate?.createTracker(tracker, currentCategory)
    }
    
    private func checkRequiredField() {
        let nameText = nameTextField.text ?? ""
        
        errorLabel.isHidden = nameText.count <= 38
        
        let isFormValid = !nameText.isEmpty && nameText.count <= 38 && !currentCategory.isEmpty && !currentShedule.isEmpty && !emoji.isEmpty && color != nil
        
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
        if indexPath.item == 0 {
            tableView.deselectRow(at: indexPath, animated: true)
            let viewController = CategoryViewController()
            viewController.delegate = self
            viewController.category = currentCategory
            let viewModel = CategoryViewModel(model: TrackerCategoryStore())
            viewController.initialize(viewModel: viewModel)
            present(viewController, animated: true)
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
            cell.textLabel?.text = NSLocalizedString("header.category", comment: "Заголовок категории")
            cell.detailTextLabel?.text = currentCategory
            cell.selectionStyle = .none
        } else {
            cell.textLabel?.text = NSLocalizedString("header.schedule", comment: "Заголовок расписания")
            let shorName = currentShedule.map { $0.getShortDayName }
            if shorName.count == 7 {
                cell.detailTextLabel?.text = NSLocalizedString("everyDay", comment: "Каждый день")
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

extension ActionViewController: EmojiAndColorCollectionViewDelegate {
    func selectColor(_ color: UIColor) {
        self.color = color
        checkRequiredField()
    }
    
    func selectEmoji(_ emoji: String) {
        self.emoji = emoji
        checkRequiredField()
    }
}

extension ActionViewController: CreateCategoryViewControllerDelegate {
    func setCategory(_ category: String) {
        currentCategory = category
        categoryAndSheduleTableView.reloadData()
    }
}

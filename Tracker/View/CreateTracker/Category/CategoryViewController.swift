//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Dosh on 15.04.2024.
//

import UIKit

final class CategoryViewController: UIViewController {
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.text = "Категория"
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = .ypBackground
        table.layer.masksToBounds = true
        table.layer.cornerRadius = 16
        table.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        table.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.identifer)
        table.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return table
    }()
    
    private lazy var createCategroryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Добавить категорию", for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(createCategory), for: .touchUpInside)
        return button
    }()
    
    private let placeholderLabel: UILabel = {
        let view = UILabel()
        view.text = "Привычки и события можно объединить по смыслу"
        view.textColor = .ypBlack
        view.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        view.textAlignment = .center
        return view
    }()
    
    private let placeholderImage: UIImageView = {
        let image = UIImageView(image: UIImage(named: "Placeholder"))
        image.contentMode = .center
        return image
    }()
    
    private var viewModel: CategoryViewModel?
    var category: String = ""
    private var heightConstraint: NSLayoutConstraint?
    
    func initialize(viewModel: CategoryViewModel) {
        self.viewModel = viewModel
        bind()
    }
    
    private func bind() {
        guard let viewModel = viewModel else { return }
        
        viewModel.updateCategory = { [weak self] in
            self?.showPlaceholderIfNeeded()
            self?.updateTableHeight()
            self?.tableView.reloadData()
        }
    }
    
    private func updateTableHeight() {
        let newHeight = CGFloat(viewModel?.countCategory ?? 0) * 75
        if let heightConstraint = heightConstraint {
            tableView.removeConstraint(heightConstraint)
        }
        heightConstraint = tableView.heightAnchor.constraint(equalToConstant: newHeight)
        heightConstraint?.isActive = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        setupConstraints()
        showPlaceholderIfNeeded()
        updateTableHeight()
    }
    
    private func showPlaceholderIfNeeded() {
        let isVisibleCategories = viewModel?.countCategory == 0
        tableView.isHidden = isVisibleCategories
        placeholderLabel.isHidden = !isVisibleCategories
        placeholderImage.isHidden = !isVisibleCategories
        
        if isVisibleCategories {
            NSLayoutConstraint.activate([
                placeholderImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
                placeholderImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
                placeholderLabel.topAnchor.constraint(equalTo: placeholderImage.bottomAnchor, constant: 8),
                placeholderLabel.centerXAnchor.constraint(equalTo: placeholderImage.centerXAnchor),
            ])
        } else {
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 24),
                tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
                tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            ])
        }
    }
    
    private func setupConstraints() {
        [headerLabel, tableView, placeholderLabel, placeholderImage, createCategroryButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            headerLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            createCategroryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            createCategroryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            createCategroryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            createCategroryButton.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    @objc private func createCategory() {
        let viewController = CreateCategoryViewController()
        if let viewModel = viewModel {
            viewController.initialize(viewModel: viewModel)
        }
        present(viewController, animated: true)
    }
    
}

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        category = viewModel?.getCategory(indexPath) ?? ""
        tableView.reloadData()
    }
}

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.countCategory ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifer, for: indexPath) as? CategoryTableViewCell else {
            return UITableViewCell()
        }
        let categoryName = viewModel?.getCategory(indexPath)
        if categoryName == category {
            cell.setSelected(true)
        } else {
            cell.setSelected(false)
        }
        cell.textLabel?.text = categoryName
        return cell
    }
}

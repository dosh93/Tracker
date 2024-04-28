//
//  FiltersViewController.swift
//  Tracker
//
//  Created by Dosh on 27.04.2024.
//

import UIKit

final class FiltersViewController: UIViewController {
    
    weak var delegate: FilterViewControllerDelegate?
    
    private let headerLabel: UILabel = {
        let laber = UILabel()
        laber.text = NSLocalizedString("filter", comment: "Заголовок выбора фильтров")
        laber.textColor = .ypBlack
        laber.textAlignment = .center
        laber.font = .systemFont(ofSize: 16, weight: .medium)
        return laber
    }()
    
    private let filtersTableView: UITableView = {
        let view = UITableView(frame: .zero)
        view.backgroundColor = .ypBackground
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.register(FiltersTableViewCell.self, forCellReuseIdentifier: FiltersTableViewCell.identifer)
        view.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return view
    }()
    
    private let currentFilter: Filters
    
    init(filter: Filters) {
        currentFilter = filter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        
        filtersTableView.delegate = self
        filtersTableView.dataSource = self
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        [headerLabel, filtersTableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            headerLabel.heightAnchor.constraint(equalToConstant: 70),
            headerLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            
            filtersTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            filtersTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            filtersTableView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 10),
            filtersTableView.heightAnchor.constraint(equalToConstant: CGFloat(75 * Filters.allCases.count)),
        ])
    }
}

extension FiltersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectFilter(Filters.allCases[indexPath.row])
        dismiss(animated: true)
    }
}

extension FiltersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Filters.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FiltersTableViewCell.identifer, for: indexPath) as? FiltersTableViewCell else {
            return UITableViewCell()
        }
        let filter = Filters.allCases[indexPath.row]
        if filter == currentFilter {
            cell.setSelected(true)
        } else {
            cell.setSelected(false)
        }
        cell.textLabel?.text = filter.localizedName
        return cell
    }
}

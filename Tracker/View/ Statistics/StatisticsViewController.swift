//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Dosh on 27.04.2024.
//

import UIKit

final class StatisticsViewController: UIViewController {

    private let trackersRecord = TrackerRecordStore()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.allowsSelection = false
        table.separatorStyle = .none
        table.backgroundColor = .ypWhite
        return table
    }()
    
    
    private let emptyImageView: UIImageView = {
        guard let image = UIImage(named: "NotFound") else { return UIImageView() }
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("statistic.empty", comment: "")
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        navigationItem.title = NSLocalizedString("statistic.header", comment: "")
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .ypWhite
        tableView.register(StatisticsTableViewCell.self, forCellReuseIdentifier: StatisticsTableViewCell.identifier)
        hideEmptyError()
        setConstraints()
    }
    
    private func hideEmptyError() {
        let count = trackersRecord.countCompleted()
        
        emptyLabel.isHidden = count != 0
        emptyImageView.isHidden = count != 0
        
        tableView.isHidden = count == 0
    }
    
    func setConstraints() {
        [tableView,
         emptyImageView,
         emptyLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            emptyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyImageView.heightAnchor.constraint(equalToConstant: 80),
            emptyImageView.widthAnchor.constraint(equalToConstant: 80),
            
            emptyLabel.topAnchor.constraint(equalTo: emptyImageView.bottomAnchor, constant: 8),
            emptyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            emptyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}

extension StatisticsViewController: TrackersViewControllerDelegate {
    func updateStatistic() {
        tableView.reloadData()
        hideEmptyError()
    }
}

extension StatisticsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
}

extension StatisticsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: StatisticsTableViewCell.identifier, for: indexPath) as? StatisticsTableViewCell
        else {  return UITableViewCell()}
        
        let count = trackersRecord.countCompleted()
        cell.set(count: count, title: NSLocalizedString("statistic.trackerCompleted", comment: ""))
        
        return cell
    }
}



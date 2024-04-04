//
//  SheduleViewController.swift
//  Tracker
//
//  Created by Dosh on 03.04.2024.
//

import UIKit

final class SheduleViewController: UIViewController {
    
    weak var delegate: SheduleViewControllerDelegate?
    private let headerLabel: UILabel = {
        let view = UILabel()
        view.text = "Расписание"
        view.textColor = .ypBlack
        view.textAlignment = .center
        view.font = .systemFont(ofSize: 16, weight: .medium)
        return view
    }()
    
    private let weekdayTableView: UITableView = {
        let view = UITableView(frame: .zero)
        view.backgroundColor = .ypBackground
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 16
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.register(WeekdayCell.self, forCellReuseIdentifier: WeekdayCell.identifer)
        view.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        return view
    }()
    
    private let setSheduleButton: UIButton = {
        let view = UIButton()
        view.setTitle("Готово", for: .normal)
        view.setTitleColor(.ypWhite, for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        view.backgroundColor = .ypBlack
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    private var selectedWeekdays: [Weekday] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        
        weekdayTableView.delegate = self
        weekdayTableView.dataSource = self
        
        setSheduleButton.addTarget(self, action: #selector(setShedule), for: .touchUpInside)
        
        setupConstraints()
    }
    
    
    @objc
    private func setShedule() {
        self.dismiss(animated: true)
        delegate?.addShedule(selectedWeekdays)
    }
    
    private func setupConstraints() {
        [setSheduleButton, weekdayTableView, headerLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            headerLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            weekdayTableView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 38),
            weekdayTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            weekdayTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            weekdayTableView.heightAnchor.constraint(equalToConstant: 75 * 7),
            
            setSheduleButton.heightAnchor.constraint(equalToConstant: 60),
            setSheduleButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            setSheduleButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            setSheduleButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20)
        ])
    }
}

extension SheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        weekdayTableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Weekday.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WeekdayCell.identifer, for: indexPath) as? WeekdayCell else {
            return UITableViewCell()
        }
        let day = Weekday.allCases[indexPath.row]
        cell.switchChanged = { [weak self] (isOn, day) in
            if isOn {
                self?.selectedWeekdays.append(day)
            } else {
                self?.selectedWeekdays.removeAll { $0 == day }
            }
        }
        cell.textLabel?.text = day.rawValue
        cell.representedDay = day
        return cell
    }
    
}

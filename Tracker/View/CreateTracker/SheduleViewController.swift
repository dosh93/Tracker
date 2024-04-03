//
//  SheduleViewController.swift
//  Tracker
//
//  Created by Dosh on 03.04.2024.
//

import UIKit

final class SheduleViewController: UIViewController {
    
    weak var delegate: SheduleViewControllerDelegate?
    private let headerLabel = UILabel()
    private let weekdayTableView = UITableView(frame: .zero)
    private let setSheduleButton = UIButton()
    private var selectedWeekdays: [Weekday] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        
        initHeaderLabel()
        initWeekdayTableView()
        inintSetSheduleButton()
        
        setupConstraints()
    }
    
    private func initHeaderLabel() {
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.text = "Расписание"
        headerLabel.textColor = .ypBlack
        headerLabel.textAlignment = .center
        headerLabel.font = .systemFont(ofSize: 16, weight: .medium)
        view.addSubview(headerLabel)
    }
    
    private func initWeekdayTableView() {
        weekdayTableView.translatesAutoresizingMaskIntoConstraints = false
        weekdayTableView.delegate = self
        weekdayTableView.dataSource = self
        weekdayTableView.backgroundColor = .ypBackground
        weekdayTableView.layer.masksToBounds = true
        weekdayTableView.layer.cornerRadius = 16
        weekdayTableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        weekdayTableView.register(WeekdayCell.self, forCellReuseIdentifier: WeekdayCell.identifer)
        weekdayTableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        view.addSubview(weekdayTableView)
    }
    
    private func inintSetSheduleButton() {
        setSheduleButton.translatesAutoresizingMaskIntoConstraints = false
        setSheduleButton.setTitle("Готово", for: .normal)
        setSheduleButton.setTitleColor(.ypWhite, for: .normal)
        setSheduleButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        setSheduleButton.backgroundColor = .ypBlack
        setSheduleButton.layer.cornerRadius = 16
        setSheduleButton.layer.masksToBounds = true
        setSheduleButton.addTarget(self, action: #selector(setShedule), for: .touchUpInside)
        view.addSubview(setSheduleButton)
    }
    
    @objc
    private func setShedule() {
        self.dismiss(animated: true)
        delegate?.addShedule(selectedWeekdays)
    }
    
    private func setupConstraints() {
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

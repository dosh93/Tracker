//
//  ViewController.swift
//  Tracker
//
//  Created by Dosh on 09.03.2024.
//

import UIKit

final class TrackerViewController: UIViewController {
    
    var categories: [TrackerCategory] = [
        TrackerCategory(
            title: "Спорт",
            trackers: [
                Tracker(id: UUID(),
                        name: "Фитнес",
                        color: .ypColor1,
                        emoji: "🏃",
                        schedule: [.thu, .sat], isRegular: true),
                Tracker(
                    id: UUID(),
                    name: "Настольный теннис",
                    color: .ypColor2,
                    emoji: "🏓",
                    schedule: [.mon, .wed, .fri], isRegular: true),
                Tracker(
                    id: UUID(),
                    name: "Йога",
                    color: .ypColor3,
                    emoji: "🧘‍♂️",
                    schedule: [.mon], isRegular: true),
            ]),
        TrackerCategory(
            title: "Отдых",
            trackers: [
                Tracker(
                    id: UUID(),
                    name: "Просмотр фильма",
                    color: .ypColor4,
                    emoji: "📺",
                    schedule: [.fri, .sat], isRegular: true),
                Tracker(
                    id: UUID(),
                    name: "Встреча с друзьями",
                    color: .ypColor5,
                    emoji: "🍻",
                    schedule: [.mon], isRegular: true),
            ]),
        TrackerCategory(
            title: "Отдых2",
            trackers: [
                Tracker(
                    id: UUID(),
                    name: "Просмотр фильма",
                    color: .ypColor4,
                    emoji: "📺",
                    schedule: [.fri, .sat], isRegular: true),
                Tracker(
                    id: UUID(),
                    name: "Встреча с друзьями",
                    color: .ypColor5,
                    emoji: "🍻",
                    schedule: [.mon], isRegular: true),
            ])
    ]
    var completedTrackers: [TrackerRecord] = []
    var visibleTrackers: [TrackerCategory] = []
    var currentDate = Date()
    
    private let datePicker = UIDatePicker()
    private let searchTextFiled = UISearchTextField()
    private let placeholderLabel = UILabel()
    private let placeholderImage = UIImageView(image: UIImage(named: "Placeholder"))
    private let trackersCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        
        trackersCollectionView.delegate = self
        trackersCollectionView.dataSource = self
        
        initDatePicker()
        initSearchTextFiled()
        initNavbar()
        setVisibleTrackersByDate()
        initPlaceholderView()
        initTrackersCollectionView()
        
        showPlaceholderIfNeeded()
        setupConstraints()
        
        setTapGesture()
    }
    
    private func setTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    private func initSearchTextFiled() {
        searchTextFiled.translatesAutoresizingMaskIntoConstraints = false
        searchTextFiled.textColor = .ypBlack
        searchTextFiled.font = .systemFont(ofSize: 17, weight: .medium)
        searchTextFiled.placeholder = "Поиск"
        searchTextFiled.backgroundColor = .clear
        searchTextFiled.delegate = self
        view.addSubview(searchTextFiled)
    }
    
    private func initDatePicker() {
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.heightAnchor.constraint(equalToConstant: 34).isActive = true
        datePicker.widthAnchor.constraint(equalToConstant: 100).isActive = true
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.calendar.firstWeekday = 2
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }
    
    
    private func initNavbar() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.topItem?.title = "Трекеры"
        navigationBar.prefersLargeTitles = true
        navigationBar.topItem?.largeTitleDisplayMode = .always
        
        let leftButton = UIBarButtonItem(
            image: UIImage(named: "PlusTask"),
            style: .plain,
            target: self,
            action: #selector(Self.addTracker))
        leftButton.tintColor = .ypBlack
        navigationItem.leftBarButtonItem = leftButton
        
        let rightButton = UIBarButtonItem(customView: datePicker)
        navigationItem.rightBarButtonItem = rightButton
    }

    private func initTrackersCollectionView() {
        trackersCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        trackersCollectionView.register(
            TrackerCollectionViewCell.self,
            forCellWithReuseIdentifier: TrackerCollectionViewCell.identifier
        )
        trackersCollectionView.register(
            TrackerCollectionViewHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TrackerCollectionViewHeader.identifier
        )
        view.addSubview(trackersCollectionView)
        
        NSLayoutConstraint.activate([
            trackersCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trackersCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            trackersCollectionView.topAnchor.constraint(equalTo: searchTextFiled.bottomAnchor, constant: 34),
            trackersCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    
    @objc private func addTracker() {
        let viewController = CreateTrackerViewController()
        viewController.delegate = self
        present(viewController, animated: true)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let formattedDate = dateFormatter.string(from: selectedDate)
        print("Выбранная дата: \(formattedDate)")
        currentDate = selectedDate
        searchTextFiled.text = ""
        setVisibleTrackersByDate()
        trackersCollectionView.reloadData()
    }
    
    private func showPlaceholderIfNeeded() {
        if visibleTrackers.isEmpty {
            trackersCollectionView.isHidden = true
            placeholderLabel.isHidden = false
            placeholderImage.isHidden = false
        } else {
            placeholderLabel.isHidden = true
            placeholderImage.isHidden = true
            trackersCollectionView.isHidden = false
        }
    }
    
    private func setupConstraints(){
        NSLayoutConstraint.activate([
            searchTextFiled.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchTextFiled.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchTextFiled.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            searchTextFiled.heightAnchor.constraint(equalToConstant: 36),
        ])
    }
    
    private func initPlaceholderView() {
        placeholderImage.contentMode = .center
        
        placeholderLabel.text = "Что будем отслеживать?"
        placeholderLabel.textColor = .ypBlack
        placeholderLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        placeholderLabel.textAlignment = .center
        
        placeholderImage.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(placeholderImage)
        view.addSubview(placeholderLabel)
        
        NSLayoutConstraint.activate([
            placeholderImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            placeholderImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            placeholderLabel.topAnchor.constraint(equalTo: placeholderImage.bottomAnchor, constant: 8),
            placeholderLabel.centerXAnchor.constraint(equalTo: placeholderImage.centerXAnchor)
        ])
    }
    
    func setVisibleTrackersByDate() {
        let weekday = Calendar.current.component(.weekday, from: currentDate)
        let todayWeekday = Weekday.allCases.first { $0.getDayNumber == weekday }
        
        visibleTrackers = getVisibleTrackersByDate()
        showPlaceholderIfNeeded()
    }
    
    private func getVisibleTrackersByDate() -> [TrackerCategory] {
        let weekday = Calendar.current.component(.weekday, from: currentDate)
        let todayWeekday = Weekday.allCases.first { $0.getDayNumber == weekday }
        
        return categories.compactMap { category -> TrackerCategory? in
            let filteredTrackers = category.trackers.filter { tracker in
                if let todayWeekday = todayWeekday {
                    if tracker.isRegular {
                        return tracker.schedule.contains(todayWeekday)
                    } else {
                        let isCompletedToday = completedTrackers.contains(where: { record in
                            record.idTracker == tracker.id && isEqualDate(date1: record.date, date2: currentDate)
                        })
                        let isNotCompleted = !completedTrackers.contains(where: { $0.idTracker == tracker.id })
                        return isCompletedToday || isNotCompleted
                    }
                }
                return false
            }
            
            if !filteredTrackers.isEmpty {
                return TrackerCategory(title: category.title, trackers: filteredTrackers)
            } else {
                return nil
            }
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension TrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - 16 * 2 - 9
        let cellWidth =  availableWidth / 2
        return CGSize(width: cellWidth, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 46)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        visibleTrackers.count
    }
}

extension TrackerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        visibleTrackers[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCollectionViewCell.identifier, for: indexPath) as? TrackerCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        cell.prepareForReuse()
        cell.delegate = self
        
        let tracker = visibleTrackers[indexPath.section].trackers[indexPath.row]
        let countCompleted = completedTrackers.filter{ $0.idTracker == tracker.id }.count
        let isCompleted = completedTrackers.contains(where: { $0.idTracker == tracker.id && isEqualDate(date1: $0.date, date2: currentDate)})
        let isEnabled = isDate(currentDate, lessThan: Date()) || isEqualDate(date1: currentDate, date2: Date())
        cell.initByData(id: tracker.id, indexPath: indexPath, emoji: tracker.emoji, name: tracker.name, color: tracker.color, countCompleted: countCompleted, isCompleted: isCompleted, isEnabled: isEnabled)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let cell = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: TrackerCollectionViewHeader.identifier,
            for: indexPath) as? TrackerCollectionViewHeader
        {
            cell.headerLabel.text = visibleTrackers[indexPath.section].title
            return cell
        } else {
            return UICollectionReusableView()
        }
    }
}

extension TrackerViewController: TrackerCellDelegate {
    func trackerCompleted(for id: UUID, at indexPath: IndexPath) {
        if let index = completedTrackers.firstIndex(where: { tracker in
            tracker.idTracker == id && isEqualDate(date1: tracker.date, date2: datePicker.date)
        }) {
            completedTrackers.remove(at: index)
        } else {
            completedTrackers.append(TrackerRecord(idTracker: id, date: datePicker.date))
        }
        trackersCollectionView.reloadItems(at: [indexPath])
    }
    
    func isEqualDate(date1: Date, date2: Date) -> Bool {
        return Calendar.current.dateComponents([.year, .month, .day], from: date1) == Calendar.current.dateComponents([.year, .month, .day], from: date2)
    }
    
    func isDate(_ date1: Date, lessThan date2: Date) -> Bool {
        let order = Calendar.current.compare(date1, to: date2, toGranularity: .day)
        return order == .orderedAscending
    }
}

extension TrackerViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text?.lowercased() else { return }
        if text.isEmpty {
            setVisibleTrackersByDate()
        } else {
            let filteredCategories: [TrackerCategory] = getVisibleTrackersByDate().map { category in
                let filteredTrackers = category.trackers.filter { $0.name.lowercased().contains(text) }
                return TrackerCategory(title: category.title, trackers: filteredTrackers)
            }.filter { !$0.trackers.isEmpty }
            visibleTrackers = filteredCategories
            showPlaceholderIfNeeded()
        }
        trackersCollectionView.reloadData()
    }
    
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        setVisibleTrackersByDate()
        trackersCollectionView.reloadData()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension TrackerViewController: CreateTrackerViewControllerDelegate {
    func createTracker(_ tracker: Tracker, _ category: String) {
        self.dismiss(animated: true)
        var newCategories: [TrackerCategory] = []
        var isNeedCreateNewCategory = true
        for i in 0..<categories.count {
            if categories[i].title == category {
                var newTrackers = categories[i].trackers
                newTrackers.append(tracker)
                newCategories.append(TrackerCategory(title: categories[i].title, trackers: newTrackers))
                isNeedCreateNewCategory = false
            } else {
                newCategories.append(TrackerCategory(title: categories[i].title, trackers: categories[i].trackers))
            }
        }
        if (isNeedCreateNewCategory) {
            newCategories.append(TrackerCategory(title: category, trackers: [tracker]))
        }
        categories = newCategories
        setVisibleTrackersByDate()
        trackersCollectionView.reloadData()
    }
}

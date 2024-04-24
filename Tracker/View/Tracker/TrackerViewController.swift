//
//  ViewController.swift
//  Tracker
//
//  Created by Dosh on 09.03.2024.
//

import UIKit

final class TrackerViewController: UIViewController {
    
    private let datePicker: UIDatePicker = {
        let view = UIDatePicker()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 34).isActive = true
        view.widthAnchor.constraint(equalToConstant: 100).isActive = true
        view.datePickerMode = .date
        view.preferredDatePickerStyle = .compact
        view.locale = Locale(identifier: "ru_RU")
        view.calendar.firstWeekday = 2
        return view
    }()
    
    
    private let searchTextFiled: UISearchTextField = {
        let view = UISearchTextField()
        view.textColor = .ypBlack
        view.font = .systemFont(ofSize: 17, weight: .medium)
        view.placeholder = NSLocalizedString("search", comment: "Поиск")
        view.backgroundColor = .clear
        return view
    }()
    
    private let placeholderLabel: UILabel = {
        let view = UILabel()
        view.text = NSLocalizedString("placeholder.trackerList", comment: "Что будем отслеживать?")
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
    
    private let trackersCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private lazy var trackerStore = TrackerStore(delegate: self)
    private lazy var trackerRecordStore = TrackerRecordStore(delegate: self)
    private var currentSearchText: String = ""
    private var currentWeekDay: Weekday = Weekday.mon
    private var currentDate = Date().normalized
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentWeekDay = getWeekday(currentDate: Date())
        
        view.backgroundColor = .ypWhite
        trackersCollectionView.delegate = self
        trackersCollectionView.dataSource = self
        searchTextFiled.delegate = self
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        
        filter()
        initNavbar()
        setVisibleTrackersByDate()
        registerTrackersCollection()
        
        showPlaceholderIfNeeded()
        setupConstraints()
        
        setTapGesture()
    }
    
    private func setTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    
    private func initNavbar() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        navigationBar.topItem?.title = NSLocalizedString("label.tracker", comment: "Трекеры")
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

    private func registerTrackersCollection() {
        trackersCollectionView.register(
            TrackerCollectionViewCell.self,
            forCellWithReuseIdentifier: TrackerCollectionViewCell.identifier
        )
        trackersCollectionView.register(
            TrackerCollectionViewHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: TrackerCollectionViewHeader.identifier
        )
    }
    
    
    @objc private func addTracker() {
        let viewController = CreateTrackerViewController()
        viewController.delegate = self
        present(viewController, animated: true)
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let formattedDate = dateFormatter.string(from: selectedDate)
        currentWeekDay = getWeekday(currentDate: selectedDate)
        currentDate = selectedDate.normalized
        searchTextFiled.text = ""
        currentSearchText = ""
        setVisibleTrackersByDate()
        trackersCollectionView.reloadData()
    }
    
    private func filter() {
        trackerStore.filter(weekday: currentWeekDay, searchText: currentSearchText, date: currentDate)
    }
    
    private func showPlaceholderIfNeeded() {
        let isVisibleTrackers = trackerStore.numberOfSections == 0
        trackersCollectionView.isHidden = isVisibleTrackers
        placeholderLabel.isHidden = !isVisibleTrackers
        placeholderImage.isHidden = !isVisibleTrackers
    }
    
    private func setupConstraints(){
        [searchTextFiled, placeholderLabel, placeholderImage, trackersCollectionView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            searchTextFiled.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchTextFiled.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchTextFiled.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            searchTextFiled.heightAnchor.constraint(equalToConstant: 36),
            
            placeholderImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            placeholderImage.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            placeholderLabel.topAnchor.constraint(equalTo: placeholderImage.bottomAnchor, constant: 8),
            placeholderLabel.centerXAnchor.constraint(equalTo: placeholderImage.centerXAnchor),
            
            trackersCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trackersCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            trackersCollectionView.topAnchor.constraint(equalTo: searchTextFiled.bottomAnchor, constant: 24),
            trackersCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func setVisibleTrackersByDate() {
        filter()
        showPlaceholderIfNeeded()
        trackersCollectionView.reloadData()
    }


    private func getWeekday(currentDate: Date) -> Weekday {
        let weekdayCal = Calendar.current.component(.weekday, from: currentDate)
        if let weekday = Weekday.allCases.first(where: { $0.getDayNumber == weekdayCal }) {
            return weekday
        } else {
            return Weekday.mon
        }
    }

    
    @objc private func dismissKeyboard() {
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
        trackerStore.numberOfSections
    }
}

extension TrackerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        trackerStore.numberOfRowsInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCollectionViewCell.identifier, for: indexPath) as? TrackerCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        cell.prepareForReuse()
        cell.delegate = self
        
        let tracker = trackerStore.object(at: indexPath)
        let countCompleted = trackerRecordStore.countCompleted(at: tracker?.id ?? UUID())
        let isCompleted = trackerRecordStore.objects(at: tracker?.id ?? UUID()).contains(where: { isEqualDate(date1: $0.date, date2: currentDate.normalized) })
        let isEnabled = isDate(currentDate.normalized, lessThan: Date().normalized) || isEqualDate(date1: currentDate.normalized, date2: Date().normalized)
        cell.id = tracker?.id ?? UUID()
        cell.indexPath = indexPath
        cell.update(emoji: tracker?.emoji, name: tracker?.name, color: tracker?.color, countCompleted: countCompleted, isCompleted: isCompleted, isEnabled: isEnabled)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if let cell = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: TrackerCollectionViewHeader.identifier,
            for: indexPath) as? TrackerCollectionViewHeader
        {
            cell.headerLabel.text = trackerStore.header(at: indexPath)
            return cell
        } else {
            return UICollectionReusableView()
        }
    }
}

extension TrackerViewController: TrackerCellDelegate {
    func trackerCompleted(for id: UUID, at indexPath: IndexPath) {
        trackerRecordStore.completed(at: id, date: currentDate)
        trackersCollectionView.reloadItems(at: [indexPath])
    }
    
    private func isEqualDate(date1: Date, date2: Date) -> Bool {
        return Calendar.current.dateComponents([.year, .month, .day], from: date1) == Calendar.current.dateComponents([.year, .month, .day], from: date2)
    }
    
    private func isDate(_ date1: Date, lessThan date2: Date) -> Bool {
        let order = Calendar.current.compare(date1, to: date2, toGranularity: .day)
        return order == .orderedAscending
    }
}

extension TrackerViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text?.lowercased() else { return }
        if text.isEmpty {
            currentSearchText = ""
            setVisibleTrackersByDate()
        } else {
            currentSearchText = text
            setVisibleTrackersByDate()
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
        do {
            try trackerStore.saveTracker(tracker: tracker, fromCategory: category)
        } catch {
            assertionFailure("Fail createTracker")
        }
        setVisibleTrackersByDate()
        trackersCollectionView.reloadData()
    }
}

extension TrackerViewController: StoreDelegate {
    func didUpdate() {
        showPlaceholderIfNeeded()
        trackersCollectionView.reloadData()
    }
}

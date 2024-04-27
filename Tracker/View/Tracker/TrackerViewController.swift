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
    
    private let trackersCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()
    private lazy var filterButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .ypBlue
        button.tintColor = .white
        button.setTitle(NSLocalizedString("filter", comment: "Кнопка фильтры"), for: .normal)
        button.addTarget(self, action: #selector(clickFilter), for: .touchUpInside)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        return button
    }()
    private lazy var trackerStore = TrackerStore(delegate: self)
    private lazy var trackerRecordStore = TrackerRecordStore(delegate: self)
    private var currentSearchText: String = ""
    private var currentWeekDay: Weekday = Weekday.mon
    private var currentDate = Date().normalized
    private var currentFilter = Filters.all
    
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
        
        showPlaceholderIfNeeded(isNotFound: false)
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
        setDate(selectedDate)
        setVisibleTrackersByDate()
        trackersCollectionView.reloadData()
    }
    
    private func setDate(_ date: Date) {
        currentWeekDay = getWeekday(currentDate: date)
        currentDate = date.normalized
        searchTextFiled.text = ""
        currentSearchText = ""
    }
    
    private func filter() {
        switch currentFilter {
        case .all:
            trackerStore.filter(weekday: currentWeekDay, searchText: currentSearchText, date: currentDate, isCompleted: nil)
        case .today:
            trackerStore.filter(weekday: currentWeekDay, searchText: currentSearchText, date: currentDate, isCompleted: nil)
        case .completed:
            trackerStore.filter(weekday: currentWeekDay, searchText: currentSearchText, date: currentDate, isCompleted: true)
        case .notCompleted:
            trackerStore.filter(weekday: currentWeekDay, searchText: currentSearchText, date: currentDate, isCompleted: false)
        }
        
    }
    
    private func setToday() {
        let today = Date()
        datePicker.date = today
        setDate(today)
        trackersCollectionView.reloadData()
    }
    
    private func showPlaceholderIfNeeded(isNotFound: Bool) {
        let isVisibleTrackers = trackerStore.numberOfSections == 0
        trackersCollectionView.isHidden = isVisibleTrackers
        placeholderLabel.isHidden = !isVisibleTrackers
        placeholderImage.isHidden = !isVisibleTrackers
        filterButton.isHidden = isVisibleTrackers
        if isNotFound {
            placeholderLabel.text = NSLocalizedString("notFound", comment: "")
            placeholderImage.image = UIImage(named: "NotFound")
        } else {
            placeholderLabel.text = NSLocalizedString("placeholder.trackerList", comment: "Что будем отслеживать?")
            placeholderImage.image = UIImage(named: "Placeholder")
        }
    }
    
    private func setupConstraints(){
        [searchTextFiled, placeholderLabel, placeholderImage, trackersCollectionView, filterButton].forEach {
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
            
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterButton.heightAnchor.constraint(equalToConstant: 50),
            filterButton.widthAnchor.constraint(equalToConstant: 115),
        ])
    }
    
    private func setVisibleTrackersByDate() {
        filter()
        showPlaceholderIfNeeded(isNotFound: true)
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
    
    func editTracker(_ indexPath: IndexPath) {
        let tracker = trackerStore.object(at: indexPath)
        var type = TypeView.unregular
        var tableCount = 1
        if (tracker?.isRegular ?? true) {
            type = TypeView.regular
            tableCount = 2
        }
        let category = trackerStore.category(at: indexPath)
        let countCompleted = trackerRecordStore.countCompleted(at: tracker?.id ?? UUID())
        let viewController = ActionViewController(setting: SettingActionView(header: NSLocalizedString("header.editTracker", comment: "Заголовок редактирование привычки"), tableCount: tableCount, type: type, tracker: tracker, countCompleted: countCompleted, category: category))
        viewController.createDelegate = self
        present(viewController, animated: true)
    }
    
    func deleteTracker(_ indexPath: IndexPath) {
        trackerStore.delete(indexPath)
    }
    
    func changePinTracker(_ indexPath: IndexPath) {
        trackerStore.changePinTracker(indexPath)
        trackersCollectionView.reloadData()
    }
    
    @objc func clickFilter() {
        let viewController = FiltersViewController(filter: currentFilter)
        viewController.delegate = self
        present(viewController, animated: true)
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

extension TrackerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard indexPaths.count > 0 else {
            return nil
        }
        
        let indexPath = indexPaths[0]
        
        var titleChangePinAction = NSLocalizedString("pinTracker", comment: "Контекстное меню закрепить трекер")
        
        if trackerStore.isPinned(at: indexPath) {
            titleChangePinAction = NSLocalizedString("unpinTracker", comment: "Контекстное меню открепить трекер")
        }
        
        let changePinAction = UIAction(title: titleChangePinAction) { [weak self] _ in
            self?.changePinTracker(indexPath)
        }
        
        let editAction = UIAction(title: NSLocalizedString("editTracker", comment: "Контекстное меню редактировать трекер")) { [weak self] _ in
            self?.editTracker(indexPath)
        }
        
        let deleteAction = UIAction(title: NSLocalizedString("deleteTracker", comment: "Контекстное меню удалить трекер"), attributes: .destructive) { [weak self] _ in
            let deleteAction = UIAlertAction(title: NSLocalizedString("alert.deleteTracker", comment: ""), style: .destructive) { _ in
                self?.deleteTracker(indexPath)
            }
            
            let cancelAction = UIAlertAction(title: NSLocalizedString("alert.cancelDelete", comment: ""), style: .cancel)
            
            let alert = UIAlertController(title: NSLocalizedString("alert.messageDeleteTracker", comment: ""), message: nil, preferredStyle: .actionSheet)
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            self?.present(alert, animated: true)
        }
        
        return UIContextMenuConfiguration(actionProvider: {
            actions in
            return UIMenu(children: [changePinAction, editAction, deleteAction])
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfiguration configuration: UIContextMenuConfiguration, highlightPreviewForItemAt indexPath: IndexPath) -> UITargetedPreview? {
        guard
            let cell = collectionView.cellForItem(at: indexPath) as? TrackerCollectionViewCell
        else { return nil }

        let parameters = UIPreviewParameters()
        parameters.backgroundColor = .clear
        parameters.visiblePath = UIBezierPath(roundedRect: cell.trackerView.bounds, cornerRadius: cell.trackerView.layer.cornerRadius)

        return UITargetedPreview(view: cell.trackerView, parameters: parameters)
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
            showPlaceholderIfNeeded(isNotFound: true)
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
        showPlaceholderIfNeeded(isNotFound: true)
        trackersCollectionView.reloadData()
    }
}

extension TrackerViewController: FilterViewControllerDelegate {
    func selectFilter(_ filter: Filters) {
        currentFilter = filter
        
        if (filter == .today) {
            setToday()
        }
        
        self.filter()
    }
}

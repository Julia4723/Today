//
//  ReminderViewController.swift
//  Today
//
//  Created by user on 17.06.2024.
//

import UIKit

class ReminderViewController: UICollectionViewController {
    
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Row>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Row>
    
    var reminder: Reminder {
        didSet {
            onChange(reminder)
        }
    }
    
    
    var workingReminder: Reminder // это свойство хранит внесенные пользователем данные до того момента пока юзер не сохранит или не отмени изменения
    var isAddingNewReminder = false //эта переменная указывает, добавляет ли пользователь новое напоминание или просматривает или редактирует существующее
    var onChange: (Reminder) -> Void
    private var dataSource: DataSource!
    
    init(reminder: Reminder, onChange: @escaping(Reminder) -> Void) {
        self.reminder = reminder
        self.workingReminder = reminder
        self.onChange = onChange
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        listConfiguration.showsSeparators = false
        listConfiguration.headerMode = .firstItemInSection
        let listLayout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        super.init(collectionViewLayout: listLayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        dataSource = DataSource(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Row) in return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
        
        
        if #available(iOS 16, *){
            navigationItem.style = .navigator
        }

        navigationItem.title = NSLocalizedString("Reminder", comment: "Reminder View controller title")
        
        navigationItem.rightBarButtonItem = editButtonItem
        
        updateSnapshotForViewing()
        
        
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            prepareForEditing()
        } else {
            if isAddingNewReminder {
                onChange(workingReminder)
            } else {
                prepareForViewing()// вызывается если пользователь создает новое напонимание
            }
        }
    }
    
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, row: Row) {
        let section = section(for: indexPath)
        switch (section, row) {
            //настраивается заголовок для каждого раздела
        case (_, .header(let title)):
            cell.contentConfiguration = headerConfiguration(for: cell, with: title)
            
        case(.view, _):
            cell.contentConfiguration = defaultConfiguration(for: cell, at: row)
            
        case(.title, .editableText(let title)):
            cell.contentConfiguration = titleConfiguration(for: cell, with: title)
        case(.date, .editableDate(let date)):
            cell.contentConfiguration = dateConfiguration(for: cell, with: date)
        case(.notes, .editableText(let notes)):
            cell.contentConfiguration = notesConfiguration(for: cell, with: notes)
        default:
            fatalError("Unexpected combination of section and row")
        }
        
        cell.tintColor = .black
        
    }
    
    //если пользователь отменят изменения, вернем временное рабочее напоминание в исходное состояние
    @objc func didCancelEdit() {
       workingReminder = reminder
        setEditing(false, animated: true)//выходя из режима редактирования на кнопке снова будет Edit
    }
   
    private func prepareForEditing() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(didCancelEdit))//действие, которое будет запускаться при нажатии кнопки отмены
        updateSnapshotForEditing()
    }
    

    
    private func updateSnapshotForEditing() {
        var snapshot = Snapshot()
        snapshot.appendSections([.title, .date, .notes])
        snapshot.appendItems([.header(Section.title.name), .editableText(reminder.title)], toSection: .title)
        snapshot.appendItems([.header(Section.date.name), .editableDate(reminder.dueDate)], toSection: .date)
        snapshot.appendItems([.header(Section.notes.name), .editableText(reminder.notes)], toSection: .notes)
        dataSource.apply(snapshot)
    }
    
    //если пользователь вносит изменения в рабочее напоминание в режиме редактирования, скопируем изменения в свойство напоминания , отображаемое в режиме просмотра. Его необходимо копировать только в том случае, если пользователь внес изменения
    private func prepareForViewing() {
        navigationItem.leftBarButtonItem = nil
        if workingReminder != reminder {
            reminder = workingReminder
        }
        updateSnapshotForViewing()
    }
    
    
    private func updateSnapshotForViewing() {
        var snapshot = Snapshot()
        snapshot.appendSections([.view])
        
        snapshot.appendItems([Row.header("Title"), Row.title, Row.data, Row.time, Row.notes], toSection: .view)
        dataSource.apply(snapshot)
    }
    
    private func section(for indexPath: IndexPath) -> Section {
        let sectionNumber = isEditing ? indexPath.section + 1 : indexPath.section
        guard let section = Section(rawValue: sectionNumber) else {
            fatalError("Unable to find matching section")
        }
        return section
    }
    
    
}



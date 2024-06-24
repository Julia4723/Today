//
//  ReminderListViewController + DataSource.swift
//  Today
//
//  Created by user on 16.06.2024.
//

import UIKit


//MARK: - DataSource methods
extension ReminderListViewController {
    
    
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Reminder.ID>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Reminder.ID>
    
    var reminderCompleteValue: String {
        NSLocalizedString("Completed", comment: "Reminder complete value")
    }
    
    var reminderNotCompleteValue: String {
        NSLocalizedString("Not completed", comment: "Reminder not complete value")
    }
    
    func updateSnapshot(realLoading idsThatChanged: [Reminder.ID] = []) {
        let ids = idsThatChanged.filter { id in
            filteredReminders.contains(where: {$0.id == id})}
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(filteredReminders.map {$0.id})//здесь используется уже отфильтрованный массив
        if !ids.isEmpty {
            snapshot.reloadItems(ids)
        }
        dataSource.apply(snapshot)
        headerView?.progress = progress
    }
    
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, id: Reminder.ID) {
        let reminder = reminder(withId: id)
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = reminder.title
        contentConfiguration.textProperties.color = .white
        contentConfiguration.secondaryText = reminder.dueDate.dayAndTimeText
        contentConfiguration.secondaryTextProperties.color = .appLightBlue
        contentConfiguration.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .caption1)
        cell.contentConfiguration = contentConfiguration
        
        var doneButtonConfiguration = doneButtonConfiguration(for: reminder)
        doneButtonConfiguration.tintColor = .appLightBlue
        cell.accessories = [.customView(configuration: doneButtonConfiguration), .disclosureIndicator(displayed: .always)]
        
        cell.accessibilityCustomActions = [doneButtonAccessibilityAction(fir: reminder)]

        cell.accessibilityValue = reminder.isComplete ? reminderCompleteValue : reminderNotCompleteValue
        
        var backgroundConfiguration = UIBackgroundConfiguration.listGroupedCell()
        backgroundConfiguration.backgroundColor = .clear
        cell.backgroundConfiguration = backgroundConfiguration
        
    }
    
    
    func reminder(withId id: Reminder.ID) -> Reminder {
        let index = reminders.indexOfReminder(withId: id)
        return reminders[index]
    }
    
    
    //метод обновляет запись
    func updateReminder(_ reminder: Reminder) {
        let index = reminders.indexOfReminder(withId: reminder.id)
        reminders[index] = reminder
    }
    
    //менять значение у записи, когда отмечаем сделанной запись
    func completeReminder(withId id: Reminder.ID) {
        var reminder = reminder(withId: id)
        reminder.isComplete.toggle()
        updateReminder(reminder)
        updateSnapshot(realLoading: [id])
    }
    
    
    func addReminder(_ reminder: Reminder) {
        reminders.append(reminder)
    }
    
    
    //метод удаляет напоминание с по идентификатору
    func deleteReminder(withId id: Reminder.ID) {
        let index = reminders.indexOfReminder(withId: id)
        reminders.remove(at: index)
    }
    
    private func doneButtonAccessibilityAction(fir reminder: Reminder) -> UIAccessibilityCustomAction {
        let name = NSLocalizedString("Toggle completion", comment: "Reminder done button accessibility label")
        let action = UIAccessibilityCustomAction(name: name) { [weak self] action in
            self?.completeReminder(withId: reminder.id)
            return true
        }
        return action
    }
    
    
    //метод для кнопки о том что задача сделана
    private func doneButtonConfiguration(for reminder: Reminder) -> UICellAccessory.CustomViewConfiguration {
        
        let symbolName = reminder.isComplete ? "circle.fill" : "circle"
        
        let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title1)
        let symbolImage = UIImage(systemName: symbolName, withConfiguration: symbolConfiguration)
        let button = ReminderDoneButton()
        button.addTarget(self, action: #selector(didPressDoneButton(_ :)), for: .touchUpInside)
        button.id = reminder.id
        button.setImage(symbolImage, for: .normal)
        
        return UICellAccessory.CustomViewConfiguration(customView: button, placement: .leading(displayed: .always))
    }
    
}

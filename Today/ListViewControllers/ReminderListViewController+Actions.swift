//
//  ReminderListViewController+Actions.swift
//  Today
//
//  Created by user on 17.06.2024.
//

import UIKit

extension ReminderListViewController {
    @objc func didPressDoneButton(_ sender: ReminderDoneButton) {
        guard let id = sender.id else {return}
        completeReminder(withId: id)
    }
    
    //метод для создания новых напоминаний
    @objc func didPressAddButton(_ sender: UIBarButtonItem) {
        let reminder = Reminder(title: "",dueDate: Date.now)
        
        //метод для сохранения нового напоминания, когда пользователь нажимает кнопку готово
        let viewController = ReminderViewController(reminder:reminder) { [weak self] reminder in
            self?.addReminder(reminder)
            self?.updateSnapshot()
            self?.dismiss(animated: true)
        }
        viewController.isAddingNewReminder = true
        viewController.setEditing(true, animated: false)
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didCancelAdd(_:)))
        viewController.navigationItem.title = NSLocalizedString("AddReminder", comment: "Add reminder view controller title")
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true)
    }
    
    //метод для создания кнопки отмены
    @objc func didCancelAdd(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @objc func didChangeListStyle(_ sender: UISegmentedControl) {
        listStyle = ReminderListStyle(rawValue: sender.selectedSegmentIndex) ?? .today
        updateSnapshot()
    }
}

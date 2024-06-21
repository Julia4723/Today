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
}

//
//  ReminderViewController + CellConfiguration.swift
//  Today
//
//  Created by user on 21.06.2024.
//

import UIKit

extension ReminderViewController {
    func defaultConfiguration(for cell: UICollectionViewListCell, at row: Row) -> UIListContentConfiguration {
        var contentConfiguration = cell.defaultContentConfiguration()//в этой конфигурации строкам присваивается стиль по умолчанию
        contentConfiguration.text = text(for: row)
        contentConfiguration.textProperties.font = UIFont.preferredFont(forTextStyle: row.textStile)
        contentConfiguration.image = row.image
        return contentConfiguration
    }
    
    func headerConfiguration(for cell: UICollectionViewListCell, with title: String) -> UIListContentConfiguration {
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = title
        return contentConfiguration
    }
    
    func titleConfiguration(for cell: UICollectionViewListCell, with title: String?) -> TextFieldContentView.Configuration {
        var contentConfiguration = cell.textFieldConfiguration()
        contentConfiguration.text = title
        
        //чтобы в рабочем напоминании всегда были последние изменения, внесенные пользователем, необходимо обновлять свойство заголовка рабочего напоминания каждый раз, когда изменяется текст в элементе управления текстовым полем
        contentConfiguration.onChange = { [weak self] title in
            self?.workingReminder.title = title}
        
        return contentConfiguration
        
    }
    
    func dateConfiguration(for cell: UICollectionViewListCell, with date: Date) -> DataPickerContentView.Configuration {
        var contentConfiguration = cell.datePickerConfiguration()
        contentConfiguration.date = date
        
        //необходимо обновлять свойство даты рабочего напоминания каждый раз, когда изменяется дата в элементе управления. присваивается новая дата для workingReminder
        contentConfiguration.onChange = { [weak self] date in
            self?.workingReminder.dueDate = date}
        return contentConfiguration
        
    }
    
    func notesConfiguration(for cell: UICollectionViewListCell, with notes: String?) -> TextViewContentView.Configuration {
        var contentConfiguration = cell.textViewConfiguration()
        contentConfiguration.text = notes
        
        //присваивает обновленные заметки для workingReminder
        contentConfiguration.onChange = { [weak self] notes in
            self?.workingReminder.notes = notes
        }
        return contentConfiguration
        
    }
    
    
    func text(for row: Row) -> String? {
        switch row {
        case .data:
            return reminder.dueDate.dayText
        case .notes:
            return reminder.notes
        case .time:
            return reminder.dueDate.formatted(date: .omitted, time: .shortened)
        case .title:
            return reminder.title
        default: return nil
        }
    }
}

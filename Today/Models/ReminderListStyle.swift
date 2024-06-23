//
//  ReminderListStyle.swift
//  Today
//
//  Created by user on 23.06.2024.
//

import Foundation

enum ReminderListStyle: Int {
    case today
    case future
    case all
    
    
    //значения для заголовков сегментов управления
    var name: String {
        switch self {
        case .today:
            return NSLocalizedString("Today", comment: "Today style name")
        case .future:
            return NSLocalizedString("Future", comment: "Future style name")
        case .all:
            return NSLocalizedString("All", comment: "All style name")
        }
    }
    
    func shouldInclude(date:Date) -> Bool {
        let isInToday = Locale.current.calendar.isDateInToday(date)
        switch self {
        case .today:
            return isInToday
        case .future:
            return (date > Date.now) && !isInToday
        case .all:
            return true
        }
    }
}

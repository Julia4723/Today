//
//  ReminderViewController + Section.swift
//  Today
//
//  Created by user on 21.06.2024.
//

import Foundation


extension ReminderViewController {
    enum Section: Int, Hashable {
        case view
        case title
        case date
        case notes
        
        var name : String {
            switch self {
            case .view:
                return ""
            case .title:
                return NSLocalizedString("Title", comment: "Title section name")
                
            case .date:
                return NSLocalizedString("Date", comment: "Title section name")
            case .notes:
                return NSLocalizedString("Notes", comment: "Title section name")
            }
        }
    }
}

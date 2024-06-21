//
//  ReminderViewController+Row.swift
//  Today
//
//  Created by user on 17.06.2024.
//

import UIKit

extension ReminderViewController {
    enum Row: Hashable {
        case data
        case notes
        case time
        case title
        
        var imageName: String? {
            switch self {
            case .data: 
                return "calendar.circle"
            case .notes:
                return "square.and.pencil"
            case .time:
                return "clock"
            default: return nil
            }
        }
        
        var image: UIImage? {
            guard let imageName = imageName else {return nil}
            let configuration = UIImage.SymbolConfiguration(textStyle: .headline)
            return UIImage(systemName: imageName, withConfiguration: configuration)
        }
        
        var textStile: UIFont.TextStyle {
            switch self {
            case .title:
                return .headline
            default: return .subheadline
            }
        }
    }
}

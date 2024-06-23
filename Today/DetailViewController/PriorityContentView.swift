//
//  PriorityContentView.swift
//  Today
//
//  Created by user on 21.06.2024.
//

import UIKit

/*
struct ReminderContentConfiguration: UIContentConfiguration {
    var reminder: Reminder // This is a copy of the model.
    
    func makeContentView() -> UIView & UIContentView {
        return PriorityContentView(self)
    }
    func updated(for state: UIConfigurationState) -> ReminderContentConfiguration {
        return self
    }
    mutating func updatePriority(to newPriority: Int) {
        reminder.currentPriority = newPriority
    }
}

class PriorityContentView : UIView, UIContentView {
    var configuration: any UIContentConfiguration
    
    
    // Define the UI elements.
    let priorityLabel = UILabel()
    let prioritySlider = UISlider()
    var priorityStack = UIStackView()
    
    init() {
        // Apply style to the user interface.
        priorityStack = UIStackView(arrangedSubviews: [priorityLabel, prioritySlider])
        priorityStack.axis = .vertical
        self.addSubview(priorityStack)
        
        priorityLabel.textAlignment = .center
        priorityLabel.textColor = .white
        
        prioritySlider.maximumValue = 10.0
        prioritySlider.minimumValue = 0.0
        prioritySlider.addTarget(self, action: #selector(self.sliderValueDidChange(_:)), for: .valueChanged)
        
        // Lay out the stack in the superview.
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
*/


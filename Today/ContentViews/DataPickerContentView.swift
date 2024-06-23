//
//  DataPickerContentView.swift
//  Today
//
//  Created by user on 23.06.2024.
//

import UIKit

class DataPickerContentView: UIView, UIContentView {
    
    struct Configuration: UIContentConfiguration {
        var date = Date.now
        var onChange: (Date) -> Void = {_ in}
        
        
        func makeContentView() -> any UIView & UIContentView {
            return DataPickerContentView(self)
        }
        
        
    }
    
    let dataPiker = UIDatePicker()
    var configuration: UIContentConfiguration {
        didSet {
            configure(configuration: configuration)
        }
    }
    
    
    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        dataPiker.addTarget(self, action: #selector(didPick(_:)), for: .valueChanged)
        //добавляя цель и действие, представление вызывает селектор всякий раз, когда элемент управления обнаруживает взаимодействие с пользователем, то есть когда пользователь изменяет дату в поле.
        addPinnedSubview(dataPiker)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? Configuration else {return}
        dataPiker.date = configuration.date
        dataPiker.preferredDatePickerStyle = .inline
    }
    
    //метод, который будет вызываться при изменении даты
    @objc private func didPick(_ sender: UIDatePicker) {
        guard let configuration = configuration as? DataPickerContentView.Configuration else {return}
        configuration.onChange(sender.date)
    }
}

extension UICollectionViewListCell {
    func datePickerConfiguration() -> DataPickerContentView.Configuration {
        DataPickerContentView.Configuration()
    }
}

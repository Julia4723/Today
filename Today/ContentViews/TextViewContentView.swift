//
//  TextViewContentView.swift
//  Today
//
//  Created by user on 23.06.2024.
//

import UIKit

class TextViewContentView: UIView, UIContentView {
    
    
    struct Configuration: UIContentConfiguration {
        var text: String? = ""
        var onChange: (String) -> Void = {_ in}
        
        
        func makeContentView() -> any UIView & UIContentView {
            return TextViewContentView(self)
        }
        
        
    }
    
    let textView = UITextView()
    var configuration: UIContentConfiguration {
        didSet {
            configure(configuration: configuration)
        }
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: 0, height: 44)
    }
    
    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        
        addPinnedSubview(textView, height: 200)
        textView.backgroundColor = nil
        textView.delegate = self // назначаем делегирование элемента управления представлением текста. Таким образом, отслеживается взаимодействие пользователя с элементом управления представлением текста
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? Configuration else {return}
        textView.text = configuration.text
        
    }
}

extension UICollectionViewListCell {
    func textViewConfiguration() -> TextViewContentView.Configuration {
        TextViewContentView.Configuration()
    }
}

//подписываем под делегата чтобы вызывать этот метод когда пользователь взаимодействует с текстовым полем
extension TextViewContentView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let configuration = configuration as? TextViewContentView.Configuration else { return}
        configuration.onChange(textView.text)
    }
}

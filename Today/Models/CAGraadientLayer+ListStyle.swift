//
//  CAGraadientLayer+ListStyle.swift
//  Today
//
//  Created by user on 24.06.2024.
//

import UIKit


//класс CAGradientLayer представляет цветовой градиент
extension CAGradientLayer {
    static func gradientLayer(for style: ReminderListStyle, in frame: CGRect) -> Self {
        let layer = Self()
        layer.colors = colors(for: style)
        layer.frame = frame
        return layer
    }
    
    
    private static func colors(for style: ReminderListStyle) -> [CGColor] {
        let beginColor: UIColor
        let endColor: UIColor
        
        switch style {
        case .today:
            beginColor = .appLightGradient
            endColor = .appDarkGradient
        case .future:
            beginColor = .appLightGradient
            endColor = .appDarkGradient
        case .all:
            beginColor = .appLightGradient
            endColor = .appDarkGradient
        }
        
        return[beginColor.cgColor, endColor.cgColor]
    }
    
}

//
//  UIView+Extension.swift
//  WeatherApp
//
//  Created by Kiran Solanke on 18/08/23.
//

import UIKit

extension UIView {
    
    func addShadow(color: UIColor = .black, opacity: Float = 0.5, offset: CGSize = CGSize(width: 0, height: 10), radius: CGFloat = 24) {
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
    }
    
    func addBorder(color: UIColor, width: CGFloat = 1) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
    
    func roundCorners(cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
    }
}

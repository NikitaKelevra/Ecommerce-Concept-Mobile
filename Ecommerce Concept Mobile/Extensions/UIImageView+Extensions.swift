//
//  UIImageView+Extensions.swift
//  Ecommerce Concept Mobile
//
//  Created by Сперанский Никита on 03.09.2022.
//

import UIKit


extension UIImageView {
    
    /// Универсальная функция изменение цвета иконки
    func setImageTintColor(_ color: UIColor) {
        let tintedImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = tintedImage
        self.tintColor = color
    }
}

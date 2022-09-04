//
//  String+Extensions.swift
//  Ecommerce Concept Mobile
//
//  Created by Сперанский Никита on 02.09.2022.
//

import Foundation

import UIKit

//Расширение String для подчеркивания текста
extension String {
   func getUnderLineAttributedText() -> NSAttributedString {
       return NSMutableAttributedString(string: self, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
   }
}

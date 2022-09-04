//
//  ItemsList.swift
//  Ecommerce Concept Mobile
//
//  Created by Сперанский Никита on 27.08.2022.
//

import Foundation

 /// Секции основного экрана c соответствующими  элементами в них
struct ItemsList: Hashable {
    let section: TypeOfSection
    let items: [AnyHashable]
}

enum TypeOfSection: String, Hashable {
    case selectCategory = "Select Category"
    case hotSales
    case bestSeller = "Best Sellers"
}

//
//  ItemsList.swift
//  Ecommerce Concept Mobile
//
//  Created by Сперанский Никита on 27.08.2022.
//

import Foundation

 /// Секции основного экрана c соответствующими  элементами в них
struct ItemsList: Hashable {
    let section: TypeOfItem
    let items: [AnyHashable]
}

enum TypeOfItem: Hashable {
    case selectCategory
    case hotSales
    case bestSeller
}

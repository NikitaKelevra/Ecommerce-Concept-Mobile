//
//  ItemsList.swift
//  Ecommerce Concept Mobile
//
//  Created by Сперанский Никита on 27.08.2022.
//

import Foundation
import UIKit

// MARK: -

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

enum Item: Hashable {
    case selectCategory(CategoryElement)
    case hotSales(HomeStoreElement)
    case bestSeller(BestSeller)
}

// MARK: - CategoryElements Model

struct CategoryElement: Hashable {
    let title: String
    let picture: String
}


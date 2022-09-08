//
//  HomeStoreModels.swift
//  Ecommerce Concept Mobile
//
//  Created by Сперанский Никита on 25.08.2022.
//

import Foundation

// MARK: - ItemsList
// Секции основного экрана c соответствующими  элементами в них
struct ItemsList: Hashable {
   let section: TypeOfSection
   let items: [AnyHashable]
}

enum TypeOfSection: String, Hashable {
   case selectCategory = "Select Category"
   case hotSales
   case bestSeller = "Best Sellers"
}

// MARK: - HomeStore Model
// Модели элементов основного экрана
struct HomeStore: Codable, Hashable {
    let homeStore: [HomeStoreElement]
    let bestSeller: [BestSeller]

    enum CodingKeys: String, CodingKey {
        case homeStore = "home_store"
        case bestSeller = "best_seller"
    }
}

// MARK: - BestSeller
struct BestSeller: Codable, Hashable {
    let id: Int
    let isFavorites: Bool
    let title: String
    let priceWithoutDiscount, discountPrice: Int
    let picture: String

    enum CodingKeys: String, CodingKey {
        case id
        case isFavorites = "is_favorites"
        case title
        case priceWithoutDiscount = "price_without_discount"
        case discountPrice = "discount_price"
        case picture
    }
}

// MARK: - HomeStoreElement (Hot Sales Element)
struct HomeStoreElement: Codable, Hashable {
    let id: Int
    let isNew: Bool?
    let title, subtitle: String
    let picture: String
    let isBuy: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case isNew = "is_new"
        case title, subtitle, picture
        case isBuy = "is_buy"
    }
}

// MARK: - CategoryElements Model
class CategoryElement: Hashable {
    
    let title: String
    let picture: String
    
    init(title: String, picture: String) {
        self.title = title
        self.picture = picture
    }
    
    // MARK: Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(picture)
    }
    
    static func == (lhs: CategoryElement,
                    rhs: CategoryElement) -> Bool {
        if lhs.title == rhs.title && lhs.picture == rhs.picture {
            return true
        }
        return false
    }
}

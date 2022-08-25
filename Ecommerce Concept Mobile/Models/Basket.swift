//
//  Basket.swift
//  Ecommerce Concept Mobile
//
//  Created by Сперанский Никита on 25.08.2022.
//

import Foundation

// MARK: - BasketInfo
struct BasketInfo: Codable {
    let basket: [Basket]
    let delivery, id: String
    let total: Int
}

// MARK: - Basket
struct Basket: Codable {
    let id: Int
    let images: String
    let price: Int
    let title: String
}

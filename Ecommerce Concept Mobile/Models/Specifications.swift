//
//  Specifications.swift
//  Ecommerce Concept Mobile
//
//  Created by Сперанский Никита on 25.08.2022.
//

import Foundation

// MARK: - Specifications
struct Specifications: Codable {
    let cpu, camera: String
    let capacity, color: [String]
    let id: String
    let images: [String]
    let isFavorites: Bool
    let price: Int
    let rating: Double
    let sd, ssd, title: String

    enum CodingKeys: String, CodingKey {
        case cpu = "CPU"
        case camera, capacity, color, id, images, isFavorites, price, rating, sd, ssd, title
    }
}

//
//  HotSalesCollectionViewCell.swift
//  Ecommerce Concept Mobile
//
//  Created by Сперанский Никита on 27.08.2022.
//

import UIKit

class HotSalesCollectionViewCell: UICollectionViewCell {

    static var reuseId: String = "HotSalesCollectionViewCell"

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func configure(with item: HomeStoreElement) {
//        categoryImageView.image = UIImage(named: item.picture)
//        categoryTitle = item.title
    }
}

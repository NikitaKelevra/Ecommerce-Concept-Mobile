//
//  BestSellerCollectionViewCell.swift
//  Ecommerce Concept Mobile
//
//  Created by Сперанский Никита on 27.08.2022.
//

import UIKit

class BestSellerCollectionViewCell: UICollectionViewCell {

    static var reuseId: String = "BestSellerCollectionViewCell"
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    
    func configure(with item: BestSeller) {
//        categoryImageView.image = UIImage(named: item.picture)
//        categoryTitle = item.title
    }
    
}

//
//  CategoryCollectionViewCell.swift
//  Ecommerce Concept Mobile
//
//  Created by Сперанский Никита on 27.08.2022.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    static var reuseId: String = "CategoryCollectionViewCell"
    
    private var categoryTitle = String()
    private let categoryImageView = UIImageView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 1, alpha: 1)

        categoryImageView.frame = self.bounds
        addSubview(categoryImageView)
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
    }
    
    func configure(with item: CategoryElement) {
        categoryImageView.image = UIImage(named: item.picture)
        categoryTitle = item.title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//
//  CategoryCollectionViewCell.swift
//  Ecommerce Concept Mobile
//
//  Created by Сперанский Никита on 27.08.2022.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    static var reuseId: String = "CategoryCollectionViewCell"
    
    var categoryTitle = String()
    let categoryImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 1, alpha: 1)

        categoryImageView.frame = self.bounds
        addSubview(categoryImageView)
        self.layer.cornerRadius = 4
        self.clipsToBounds = true
    }
    
    func configure(with item: CategoryElements) {
        categoryImageView.image = UIImage(named: item.picture)
        categoryTitle = item.title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

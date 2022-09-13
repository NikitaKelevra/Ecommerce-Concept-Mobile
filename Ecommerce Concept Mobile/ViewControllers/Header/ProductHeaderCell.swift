//
//  ProductHeaderCell.swift
//  Ecommerce Concept Mobile
//
//  Created by Сперанский Никита on 12.09.2022.
//

import UIKit

class ProductHeaderCell: UICollectionReusableView {
    
    //MARK: - Properties
    static let reuseId = "ProductHeader"

    /// Лейбл заголовка
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Select Category"
        label.font = UIFont(name: "avenir", size: 25)
        label.textColor = UIColor(hex: "#010035")
        return label
    }()
    
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Funcs
    private func setupElements() {
        addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

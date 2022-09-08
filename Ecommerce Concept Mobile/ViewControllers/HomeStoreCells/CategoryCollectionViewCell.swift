//
//  CategoryCollectionViewCell.swift
//  Ecommerce Concept Mobile
//
//  Created by Сперанский Никита on 27.08.2022.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {

    //MARK: - Properties
    static let reuseId: String = "CategoryCollectionViewCell"
    
    var isSelectedCategory = false
    
    /// Оранжевый кружок
    private lazy var circleImage: UIImageView  = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 71, height: 71))
        imageView.contentMode = .center
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
//        imageView.backgroundColor = UIColor(hex: "#FF6E4E") // оранжевый
        imageView.backgroundColor = .white // белый
        return imageView
    }()
    
    /// Настройка иконки
    private lazy var categoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
        imageView.setImageTintColor(UIColor(red: 179, green: 179, blue: 195, alpha: 1)) /// серый
//        imageView.setImageTintColor(UIColor(red: 255, green: 255, blue: 255, alpha: 1)) /// белый
        return imageView
    }()
    
    /// Подпись категории
    private var categoryTitleLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(12)
        label.text = "Название"
        return label
    }()
    
    /// Общий стек изображений
    let categoryStack: UIStackView = {
        let stackView = UIStackView()
        stackView.bounds.size = CGSize(width: 71, height: 91)
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 7
        return stackView
    }()
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Funcs
    func configure(with item: CategoryElement) {
        circleImage.image = UIImage(named: item.picture)
        categoryTitleLabel.text = item.title
        
    }
    
    private func addSubviews() {
        circleImage.addSubview(categoryImageView)
        categoryStack.addArrangedSubview(circleImage)
        categoryStack.addArrangedSubview(categoryTitleLabel)

        addSubview(categoryStack)
    }
    
    private func setupElements() {
        
        circleImage.translatesAutoresizingMaskIntoConstraints = false
        circleImage.leftAnchor.constraint(equalTo: categoryStack.leftAnchor).isActive = true
        circleImage.topAnchor.constraint(equalTo: categoryStack.topAnchor).isActive = true
        circleImage.widthAnchor.constraint(equalToConstant: 71).isActive = true
        circleImage.heightAnchor.constraint(equalToConstant: 71).isActive = true
        
        categoryImageView.translatesAutoresizingMaskIntoConstraints = false
        categoryImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        categoryImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true

        categoryImageView.centerYAnchor.constraint(equalTo: circleImage.centerYAnchor).isActive = true
        categoryImageView.centerXAnchor.constraint(equalTo: circleImage.centerXAnchor).isActive = true
        
        categoryStack.translatesAutoresizingMaskIntoConstraints = false
        categoryStack.widthAnchor.constraint(equalToConstant: 71).isActive = true
        categoryStack.heightAnchor.constraint(equalToConstant: 91).isActive = true
//        categoryStack.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
//        categoryStack.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        if isSelectedCategory {
            categoryImageView.tintColor = .white
            circleImage.backgroundColor = UIColor(hex: "#FF6E4E")
        }
        
    }
    
}

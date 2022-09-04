//
//  BestSellerCollectionViewCell.swift
//  Ecommerce Concept Mobile
//
//  Created by Сперанский Никита on 27.08.2022.
//

import UIKit

class BestSellerCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    static let reuseId: String = "BestSellerCollectionViewCell"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var newPriceLabel: UILabel!
    @IBOutlet weak var oldPriceLabel: UILabel!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    
    private var isFavoriteImage: String = "heart"
    
    //MARK: - Funcs
    override func awakeFromNib() {
        super.awakeFromNib()
        setupElements()
    }

    func configure(with item: BestSeller) {
        nameLabel.text = item.title
        newPriceLabel.text = "$"+String(item.priceWithoutDiscount)
        oldPriceLabel.text = "$"+String(item.discountPrice)
        getImageFromUrl(item.picture)
        if item.isFavorites { isFavoriteImage = "heart.fill" }
    }
    
    
    private func setupElements() {
        self.layer.cornerRadius = 10
        
        /// Настройка кнопки
//        favoriteButton.setImage(UIImage(named: isFavoriteImage), for: .normal)
        favoriteButton.layer.cornerRadius = favoriteButton.frame.size.width / 2
        favoriteButton.clipsToBounds = true
        favoriteButton.contentMode = .center
        favoriteButton.tintColor = UIColor(hex: "#FF6E4E")
//        favoriteButton.imageView?.tintColor = UIColor(hex: "#FF6E4E")
//        favoriteButton.imageView?.contentMode = .scaleAspectFit
//        favoriteButton.backgroundColor = .green
        favoriteButton.addTarget(self, action: #selector(addToFavorite), for: .touchUpInside)
        
        /// Настройка старой цены
        let attributedText = NSAttributedString(
            string: "Label Text",
            attributes: [.strikethroughStyle: NSUnderlineStyle.single.rawValue])
            
        oldPriceLabel.attributedText = attributedText  /// атрибут для отображения зачеркнутого текста
        oldPriceLabel.textColor = UIColor(hex: "#CCCCCC")
        
        /// Настройка изображения
//        productImageView
        
    }
    
    /// Загрузка  и установка картинки
    private func getImageFromUrl(_ url: String) {
        guard let url = URL(string: url) else { return }
        
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else { return }
            
            DispatchQueue.main.async {
                self.productImageView.image = UIImage(data: imageData)
            }
        }
    }
    
    /// функция добавления элемента в избранное
    @objc private func addToFavorite() {
        print("Добавить элемент в избранное")
    }
    
}

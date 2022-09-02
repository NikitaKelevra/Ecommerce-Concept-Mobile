//
//  HotSalesCollectionViewCell.swift
//  Ecommerce Concept Mobile
//
//  Created by Сперанский Никита on 27.08.2022.
//

import UIKit

class HotSalesCollectionViewCell: UICollectionViewCell {

    static var reuseId: String = "HotSalesCollectionViewCell"

    @IBOutlet weak var newLabel: UILabel!
    @IBOutlet weak var brandTitleLabel: UILabel!
    @IBOutlet weak var infoBrandLabel: UILabel!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var mainImageView: UIImageView!
    
    
    
    // MARK: -
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCell()
    }
    
    // MARK: -
    
    
    func configure(with item: HomeStoreElement) {
        newLabel.isEnabled = item.isNew ?? false
        brandTitleLabel.text = item.title
        infoBrandLabel.text = item.subtitle
        getImageFromUrl(item.picture)
    }
            
    // MARK: -
    /// Загрузка  и установка картинки
    private func getImageFromUrl(_ url: String) {
        guard let url = URL(string: url) else { return }
        
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: url) else { return }
            
            DispatchQueue.main.async {
                self.mainImageView.image = UIImage(data: imageData)
            }
        }
    }
    
    ///Настройка ячейки
    private func setupCell() {
//        mainImageView.layer.cornerRadius = 4
//        mainImageView.clipsToBounds = true
    }
    
    
}

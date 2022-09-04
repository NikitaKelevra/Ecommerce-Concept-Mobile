//
//  HotSalesCollectionViewCell.swift
//  Ecommerce Concept Mobile
//
//  Created by Сперанский Никита on 27.08.2022.
//

import UIKit

class HotSalesCollectionViewCell: UICollectionViewCell {

    static let reuseId: String = "HotSalesCollectionViewCell"

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
        
        showNewLabel(item.isNew)
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
    
    private func showNewLabel(_ isNew: Bool?) {
        guard let hideNew = isNew else {
            newLabel.isHidden = true
            return
        }
        newLabel.isHidden = !hideNew
    }
    
    ///Настройка ячейки
    private func setupCell() {

        ///Настройка лейбла `New`
        newLabel.attributedText = newLabel.text?.getUnderLineAttributedText()
        newLabel.layer.masksToBounds = true
        newLabel.layer.cornerRadius = newLabel.frame.width / 2
        newLabel.backgroundColor = UIColor(hex: "#FF6E4E")
        newLabel.textColor = .white

        
        ///Настройка кнопки `Buy Now!`
        buyButton.setAttributedTitle(buyButton.titleLabel?.text?.getUnderLineAttributedText(), for: .normal)
        buyButton.clipsToBounds = true
        buyButton.layer.cornerRadius = 10
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    
}

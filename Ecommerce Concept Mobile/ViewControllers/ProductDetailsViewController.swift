//
//  ProductDetailsViewController.swift
//  Ecommerce Concept Mobile
//
//  Created by Сперанский Никита on 05.09.2022.
//

import UIKit

class ProductDetailsViewController: UIViewController {

    // MARK: - Properties
    
    var collectionView: UICollectionView!
    
    typealias DataSource = UICollectionViewDiffableDataSource<detailsSections, Specifications>
    typealias Snapshot = NSDiffableDataSourceSnapshot<detailsSections, Specifications>
    
    private var dataSource: DataSource?
    
    private var sections  = detailsSections.allCases
    private var phonesDetails: [Specifications] = []

    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchItems()
        
    }
    
    // MARK: - Init
    init() {
        super.init(collectionViewLayout: UICollectionViewLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Загрузка данных в массив 'sections'
    private func fetchItems() {
        NetworkManager.shared.fetchPhonesSpecifications(completion: { specificationsData, error in
            guard let specificationsInfo = specificationsData else { return }
            self.phonesDetails.append(specificationsInfo)
            print(specificationsInfo)

            self.reloadData() /// перезагружаем интерфейс с новыми данными
        })
    }
    
    
    // MARK: - Diffable Data Source
    // Подгружает данные в CollectionView
    private func reloadData() {
        var snapshot = Snapshot()
        snapshot.appendSections(detailsSections.allCases) /// добавляем секции в снимок данных
        for section in sections {
            snapshot.appendItems(section.items, toSection: section) /// добавляем данные в секции
        }
        
        dataSource?.apply(snapshot)
    }
    
    private func createDataSourсe() {
        /// Настраивает ячейки в зависимости от типа элемента
        dataSource = DataSource(collectionView: collectionView,
                                cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            
            let cell = UICollectionViewCell()
            
            let section = self.phonesDetails[indexPath.section]
            
            switch section {
                
            }
            
            
            switch item {
            case let item as CategoryElement:
                guard let selectCategoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.reuseId,
                                                                                  for: indexPath) as? CategoryCollectionViewCell
                else { fatalError("Cannot create new cell") }
                selectCategoryCell.configure(with: item)
                return selectCategoryCell

            case let item as HomeStoreElement:
                guard let hotSalesCell = collectionView.dequeueReusableCell(withReuseIdentifier: HotSalesCollectionViewCell.reuseId,
                                                                            for: indexPath) as? HotSalesCollectionViewCell
                else { fatalError("Cannot create new cell") }
                hotSalesCell.configure(with: item)
                print("Создали ", item)
                return hotSalesCell

            case let item as BestSeller:
                guard let bestSellerCell = collectionView.dequeueReusableCell(withReuseIdentifier: BestSellerCollectionViewCell.reuseId,
                                                                              for: indexPath) as? BestSellerCollectionViewCell
                else { fatalError("Cannot create new cell") }
                bestSellerCell.configure(with: item)
                return bestSellerCell

            default: return cell
            }
        })
        
        /// Настройка заголовка в зависимости от ячейки
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                      withReuseIdentifier: SectionHeaderCell.reuseId,
                                                                                      for: indexPath) as? SectionHeaderCell else { return nil }
            guard let item = self.dataSource?.itemIdentifier(for: indexPath) else { return nil }
            guard let section = self.dataSource?.snapshot().sectionIdentifier(containingItem: item) else { return nil }
            if section.section.rawValue.isEmpty { return nil }
            sectionHeader.titleLabel.text = section.section.rawValue
            return sectionHeader
        }
    }
    
    // MARK: - CollectionViewCompositionalLayout
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let section = self.phonesDetails[sectionIndex]

            switch section.section {
            case .phoneImage:
                return self.createPhoneImageSection()
            case .phoneDetails:
                return self.createPhoneDetailsSection()
            }
        }
        return layout
    }
    
    /// Создаем `layout` для секции `Phone Image`
    private func createPhoneImageSection() -> NSCollectionLayoutSection {
        
    }
    
    /// Создаем `layout` для секции `Phone Details`
    private func createPhoneDetailsSection() -> NSCollectionLayoutSection {
        
    }
    
    
    // MARK: - Diffable Data Source
    // Подгружает данные в CollectionView
    private func reloadData() {
        var snapshot = Snapshot()
        snapshot.appendSections(phonesDetails) /// добавляем секции в снимок данных
        for section in phonesDetails {
            snapshot.appendItems(section.items, toSection: section) /// добавляем данные в секции
        }
        
//        if let items
        
        dataSource?.apply(snapshot)
    }
    
    
    
    

}

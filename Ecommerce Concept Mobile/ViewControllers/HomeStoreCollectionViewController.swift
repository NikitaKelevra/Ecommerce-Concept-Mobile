//
//  HomeStoreCollectionViewController.swift
//  Ecommerce Concept Mobile
//
//  Created by Сперанский Никита on 25.08.2022.
//

import UIKit

//private let reuseIdentifier = "Cell"

// Основной VC
class HomeStoreCollectionViewController: UICollectionViewController {
    
    
    typealias DataSourse = UICollectionViewDiffableDataSource<ItemsList, AnyHashable>
    typealias Snapshot = NSDiffableDataSourceSnapshot<ItemsList, AnyHashable>
    
    
    // MARK: - Properties
        
    var dataSourse: DataSourse?
    
    private var sections: [ItemsList] = [] {
        didSet {
            fetchProducts()  // подгружаем данные
        }
    }
    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        createDataSourse()
        reloadData()
    }
    
    
    // MARK: - Private func
    
    private func fetchProducts() {
        NetworkManager.shared.fetchHomeStoreData(completion: { homeStoreData, error in
            
//            self.homeStore = homeStoreData
            print("\(String(describing: homeStoreData))")
        })
        
    }
    
    
    
    
    // MARK: - Настройка `Collection View`
    
    
    
    func setupCollectionView() {
        
        collectionView = UICollectionView(frame: view.bounds,
                                          collectionViewLayout: UICollectionViewLayout())    //createCompositionalLayout()
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // чтобы расстягивалось по разным устройствам
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellid")
        
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.reuseId)
        collectionView.register(BestSellerCollectionViewCell.self, forCellWithReuseIdentifier: BestSellerCollectionViewCell.reuseId)
        
        collectionView.register(UINib(nibName: String(describing: HotSalesCollectionViewCell.self), bundle: nil),
                                      forCellWithReuseIdentifier: HotSalesCollectionViewCell.reuseId)
        
//        collectionView.register(UINib(nibName: String(describing: SectionHeader.self), bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: SectionHeader.self))
        
        view.addSubview(collectionView)
    }
    
    
    // MARK: - Diffable Data Source
    private func createDataSourse() {
        /// Настраивает ячейки в зависимости от секции
        dataSourse = DataSourse(collectionView: collectionView,
                                cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
                        
            
            
//            if let article = item as? Article, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Section.articles.cellIdentifier, for: indexPath) as? ArticleCell {
//                cell.article = article
//                return cell
//            }
//
//            if let image = item as? ArticleImage, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Section.trends.cellIdentifier, for: indexPath) as? ImageCell {
//                cell.image = image
//                return cell
//            }
//
//            fatalError()
//        }
            
            if let categoryItem = item as? CategoryElements,
               let selectCategoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.reuseId,
                                                                           for: indexPath) as? CategoryCollectionViewCell {
                selectCategoryCell.configure(with: categoryItem)
            return selectCategoryCell
            }
            
            if let hotSalesItem = item as? HomeStoreElement,
               let hotSalesCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HotSalesCollectionViewCell.self),
                                                                     for: indexPath) as? HotSalesCollectionViewCell {
                hotSalesCell.configure(with: hotSalesItem)
            return hotSalesCell
            }
            
            
            switch self.sections[indexPath.section].section {
                
            case .selectCategory:
                if let categoryItem = item as? CategoryElements,
                   let selectCategoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.reuseId,
                                                                               for: indexPath) as? CategoryCollectionViewCell {
                    selectCategoryCell.configure(with: categoryItem)
                return selectCategoryCell
                }
                
            case .hotSales:
                let hotSalesCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HotSalesCollectionViewCell.self), for: indexPath) as? HotSalesCollectionViewCell
                
                //                cellBuilder.configureCell(for: cell, with: viewModel.mainMenuCellViewModel(with: indexPath))
                
                return hotSalesCell
                
            case .bestSeller:
                let bestSellerCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: BestSellerCollectionViewCell.self), for: indexPath) as? BestSellerCollectionViewCell
                
                //                cellBuilder.configureCell(for: cell, with: viewModel.mainMenuCellViewModel(with: indexPath))
                
                return bestSellerCell
            }
        })
    }
    
    // Перезагружает данные в CollectionView
    private func reloadData() {
        var snapshot = Snapshot()
        snapshot.appendSections(sections) /// добавляем секции в snapshot
        for section in sections {
            snapshot.appendItems(section.items, toSection: section)
        }
        dataSourse?.apply(snapshot)
    }
    
    // MARK: - CollectionViewCompositionalLayout
    func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            let section = self.sections[sectionIndex]
            
            switch section.section {

            case .selectCategory:
                return self.createSelectCategorySection()
            case .hotSales:
                return self.createHotSalesSection()
            case .bestSeller:
                return self.createBestSellerSection()
            }
        }
        return layout
    }
    
    func createSelectCategorySection()  -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 8, bottom: 0, trailing: 8)
        
        
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .estimated(104),
                                                     heightDimension: .estimated(88))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])
        
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .continuous
        layoutSection.contentInsets = NSDirectionalEdgeInsets.init(top: 66, leading: 12, bottom: 0, trailing: 12)
        
        return layoutSection
    }
    
    func createHotSalesSection()  -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(86))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 0, bottom: 8, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(1))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 66, leading: 20, bottom: 0, trailing: 20)
        
        return section
    }
    
    func createBestSellerSection()  -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(86))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 0, bottom: 8, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(1))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 66, leading: 20, bottom: 0, trailing: 20)
        
        return section
    }
    
    
    // MARK: - UICollectionViewDataSource

//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 0
//    }
//
//
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of items
//        return 0
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
//
//        // Configure the cell
//
//        return cell
//    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

    
    
    // MARK: -
    
    
    
    
}

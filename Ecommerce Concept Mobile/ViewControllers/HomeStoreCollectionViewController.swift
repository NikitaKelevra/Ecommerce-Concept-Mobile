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
    
    // MARK: - Properties
        
    typealias DataSource = UICollectionViewDiffableDataSource<ItemsList, AnyHashable>
    typealias Snapshot = NSDiffableDataSourceSnapshot<ItemsList, AnyHashable>
    
    var dataSource: DataSource?
//    var collectionView: UICollectionView!
    
    
    private var sections: [ItemsList] = [] {
        didSet {
            fetchProducts()  // подгружаем данные
        }
    }
    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .orange
        
        setupCollectionView()
        createDataSourсe()
        setupNavigationBar()
        reloadData()
    }
    
    // MARK: - Init
    init() {
        super.init(collectionViewLayout: UICollectionViewLayout())
//        cellBuilder = CellBuilder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private func
    
    private func fetchProducts() {
        NetworkManager.shared.fetchHomeStoreData(completion: { homeStoreData, error in
            
//            self.homeStore = homeStoreData
            print("\(String(describing: homeStoreData))")
        })
        
    }
    
    // MARK: - Настройка `Collection View`

    private func setupCollectionView() {
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // добавление collectionView на экран
//        view.addSubview(collectionView)
        //регистрация ячеек
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.reuseId)
        collectionView.register(UINib(nibName: String(describing: HotSalesCollectionViewCell.self), bundle: nil),
                                forCellWithReuseIdentifier: HotSalesCollectionViewCell.reuseId)
        collectionView.register(UINib(nibName: String(describing: BestSellerCollectionViewCell.self), bundle: nil),
                                forCellWithReuseIdentifier: BestSellerCollectionViewCell.reuseId)
        
        
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
//        ])
    }
    
    
    // MARK: - Diffable Data Source
    private func createDataSourсe() {
        /// Настраивает ячейки в зависимости от секции
        dataSource = DataSource(collectionView: collectionView,
                                cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            
            switch self.sections[indexPath.section].section {
                
            case .selectCategory:
                if let categoryItem = item as? CategoryElement,
                   let selectCategoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.reuseId,
                                                                               for: indexPath) as? CategoryCollectionViewCell {
                    selectCategoryCell.configure(with: categoryItem)
                return selectCategoryCell
                }
                
            case .hotSales:
                
                
                if let hotSalesItem = item as? HomeStoreElement,
                   let hotSalesCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: HotSalesCollectionViewCell.self),
                                                                         for: indexPath) as? HotSalesCollectionViewCell {
                    hotSalesCell.configure(with: hotSalesItem)
                    return hotSalesCell
                }
                    
            case .bestSeller:
                    if let bestSellerItem = item as? BestSeller,
                       let bestSellerCell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: BestSellerCollectionViewCell.self),
                                                                               for: indexPath) as? BestSellerCollectionViewCell {
                        bestSellerCell.configure(with: bestSellerItem)
                        return bestSellerCell
                    }
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
        dataSource?.apply(snapshot)
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

    // MARK: - Navigation Bar
    private func setupNavigationBar() {
        title = "PizzaShop"
        navigationController?.navigationBar.prefersLargeTitles = true
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.backgroundColor = UIColor.brown
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
    
    // MARK: -
    
    
    
    
}

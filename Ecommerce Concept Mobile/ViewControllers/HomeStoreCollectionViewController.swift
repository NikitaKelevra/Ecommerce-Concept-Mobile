//
//  HomeStoreCollectionViewController.swift
//  Ecommerce Concept Mobile
//
//  Created by Сперанский Никита on 25.08.2022.
//

import UIKit

//private let reuseIdentifier = "Cell"

// Основной VC
final class HomeStoreCollectionViewController: UICollectionViewController {
    
    // MARK: - Properties
        
    typealias DataSource = UICollectionViewDiffableDataSource<ItemsList, AnyHashable>
    typealias Snapshot = NSDiffableDataSourceSnapshot<ItemsList, AnyHashable>
    
    var dataSource: DataSource?
    //    var collectionView: UICollectionView!
    
    
    private var sections: [ItemsList] = []
    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchItems()
        
        setupCollectionView()
        createDataSourсe()
        setupNavigationBar()
        reloadData()
        
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
        NetworkManager.shared.fetchHomeStoreData(completion: { homeStoreData, error in
            guard let bestSellerItems = homeStoreData?.bestSeller,
                  let homeStoreItems = homeStoreData?.homeStore else { return }
            let categoriesItems = self.fetchCategories(categoryArray)
            
            self.sections.append(ItemsList.init(section: .selectCategory, items: categoriesItems))
            self.sections.append(ItemsList.init(section: .bestSeller, items: bestSellerItems))
            self.sections.append(ItemsList.init(section: .hotSales, items: homeStoreItems))
            self.reloadData() /// перезагружаем интерфейс с новыми данными
        })
    }
    
    private func fetchCategories(_ categories: [(String,String)]) -> [CategoryElement] {
        var items: [CategoryElement] = []
        for category in categories {
            let item = CategoryElement.init(title: category.0, picture: category.1)
            items.append(item)
        }
        return items
    }
    
    // MARK: - Настройка `Collection View`

    private func setupCollectionView() {
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // добавление collectionView на экран
        view.addSubview(collectionView)
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
    // Подгружает данные в CollectionView
    private func reloadData() {
        var snapshot = Snapshot()
        snapshot.appendSections(sections) /// добавляем секции в снимок данных
        for section in sections {
            snapshot.appendItems(section.items, toSection: section) /// добавляем данные в секции
        }
        //        print("Всего элементов reloadData:", self.sections.count)
        dataSource?.apply(snapshot)
    }
    
    private func createDataSourсe() {
        /// Настраивает ячейки в зависимости от типа элемента
        dataSource = DataSource(collectionView: collectionView,
                                cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            
            let cell = UICollectionViewCell()
//            print("Всего элементов createDataSourсe:", self.sections.count)
//            print(item)
            switch item {

            case let item as CategoryElement:
                guard let selectCategoryCell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.reuseId,
                                                                                  for: indexPath) as? CategoryCollectionViewCell
                else { fatalError("Cannot create new cell") }
                selectCategoryCell.configure(with: item)
                print("Создали ", item)
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
                print("Создали ", item)
                return bestSellerCell

            default: return cell
            }
        })
    }
    
    
    // MARK: - CollectionViewCompositionalLayout
    private func createCompositionalLayout() -> UICollectionViewLayout {
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
    
    /// Создаем `layout` для секции `Select Category`
    private func createSelectCategorySection()  -> NSCollectionLayoutSection {
        
        let padding: CGFloat = 16
        
        /// Настройка `элемента` в группе
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(71),
                                              heightDimension: .absolute(71))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets.init(top: 0,
                                                                leading: padding,
                                                                bottom: 0,
                                                                trailing: 8)
        /// Настройка `группы` в секции
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .estimated(104),
                                                     heightDimension: .estimated(88))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize,
                                                             subitems: [layoutItem])
        /// Настройка `секции`
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .continuous
        layoutSection.contentInsets = NSDirectionalEdgeInsets.init(top: 24, leading: 12,
                                                                   bottom: 0, trailing: 23)
        return layoutSection
    }
    
    /// Создаем `layout` для секции `Hot Sales`
    private func createHotSalesSection()  -> NSCollectionLayoutSection {
        
        /// Настройка `элемента` в группе
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(221),
                                              heightDimension: .estimated(384))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 0,
                                                          bottom: 0, trailing: 8)
        
        /// Настройка `группы` в секции
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        
        /// Настройка `секции`
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 374, leading: 8,
                                                             bottom: 0, trailing: 0)
        
        return section
    }
    
    /// Создаем `layout` для секции `Best Seller`
    private func createBestSellerSection()  -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(86))
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
//        title = "PizzaShop"
        navigationController?.navigationBar.prefersLargeTitles = false
        let navBarAppearance = UINavigationBarAppearance()
//        navBarAppearance.configureWithOpaqueBackground()
//
//        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
//        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.backgroundColor = UIColor.brown
//
//        navigationController?.navigationBar.standardAppearance = navBarAppearance
//        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
    }
    
    // MARK: -
    
    
    
    
}

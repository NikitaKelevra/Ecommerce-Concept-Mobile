//
//  HomeStoreCollectionViewController.swift
//  Ecommerce Concept Mobile
//
//  Created by Сперанский Никита on 25.08.2022.
//

import UIKit
import SwiftUI

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
            self.sections.append(ItemsList.init(section: .hotSales, items: homeStoreItems))
            self.sections.append(ItemsList.init(section: .bestSeller, items: bestSellerItems))
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
        collectionView.backgroundColor = UIColor(hex: "#E5E5E5")
        /// добавление collectionView на экран
        view.addSubview(collectionView)
        /// регистрация ячеек
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.reuseId)
        collectionView.register(UINib(nibName: String(describing: HotSalesCollectionViewCell.self), bundle: nil),
                                forCellWithReuseIdentifier: HotSalesCollectionViewCell.reuseId)
        collectionView.register(UINib(nibName: String(describing: BestSellerCollectionViewCell.self), bundle: nil),
                                forCellWithReuseIdentifier: BestSellerCollectionViewCell.reuseId)
        
        collectionView.register(SectionHeaderCell.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeaderCell.reuseId)
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
        
        /// Настройка `элемента` в группе
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 0,
                                                                bottom: 0, trailing: 0)
        /// Настройка `группы` в секции
        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .estimated(100),
                                                     heightDimension: .estimated(100))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize,
                                                             subitems: [layoutItem])
        /// Настройка `секции`
        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .continuous
        layoutSection.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 17, bottom: 0, trailing: 0)
        
        /// Устанавливаем заголовок
        let header = createSectionHeader()
        layoutSection.boundarySupplementaryItems = [header]
        
        return layoutSection
    }
    
    /// Создаем `layout` для секции `Hot Sales`
    private func createHotSalesSection()  -> NSCollectionLayoutSection {
        /// Настройка `элемента` в группе
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), // 221 - 384
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 0,
                                                          bottom: 0, trailing: 0)
        /// Настройка `группы` в секции
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
        /// Настройка `секции`
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        return section
    }
    
    /// Создаем `layout` для секции `Best Seller`
    private func createBestSellerSection()  -> NSCollectionLayoutSection {
        let windowWidth = view.frame.width /// ширина экрана
        /// Настройка `элемента` в группе
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.49),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 0, bottom: 17, trailing: 17)
        /// Настройка `группы` в секции
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(windowWidth),
                                               heightDimension: .absolute(windowWidth/1.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        /// Настройка `секции`
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 17, bottom: 0, trailing: 17)
        
        /// Устанавливаем заголовок
        let header = createSectionHeader()
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    /// Настраиваем заголовок
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let layoutSectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                             heightDimension: .absolute(50))
        let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: layoutSectionHeaderSize,
                                                                              elementKind: UICollectionView.elementKindSectionHeader,
                                                                              alignment: .topLeading)
        return layoutSectionHeader
    }
}
// MARK: - SwiftUI - Для отображения Результата в Превью
import SwiftUI
struct ListProvider: PreviewProvider {
    static var previews: some View {
        ContainterView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainterView: UIViewControllerRepresentable {
        
        let listVC = HomeStoreCollectionViewController()
        func makeUIViewController(context: UIViewControllerRepresentableContext<ListProvider.ContainterView>) -> HomeStoreCollectionViewController {
            return listVC
        }
        
        func updateUIViewController(_ uiViewController: ListProvider.ContainterView.UIViewControllerType, context: UIViewControllerRepresentableContext<ListProvider.ContainterView>) {
        }
    }
}

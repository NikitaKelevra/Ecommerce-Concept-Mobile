//
//  HomeStoreCollectionViewController.swift
//  Ecommerce Concept Mobile
//
//  Created by Сперанский Никита on 25.08.2022.
//

import UIKit




private let reuseIdentifier = "Cell"



// Основной VC
class HomeStoreCollectionViewController: UICollectionViewController {
    
    // MARK: - Properties
//     private var
    
    
    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionView()
        
        fetchProducts()  // подгружвем данные
    }
    
    
    // MARK: - Private func
    
    
    
    func fetchProducts() {
        NetworkManager.shared.fetchHomeStoreData(completion: { homeStore, error in
            print(homeStore)
        })
        
//        { products in
//            self.products = products
//            completion()
//        }
    }
    
    
    
    
    
    /// Настройка `Collection View`
    func setupCollectionView() {
        
//        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
//        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        
        // Select Category
        //  Hot sales
        //  Best Sellers
        
//        collectionView.register(UINib(nibName: String(describing: MainMenuCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: MainMenuCell.self))
//        collectionView.register(UINib(nibName: String(describing: SpecialOfferCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: SpecialOfferCell.self))
//        collectionView.register(UINib(nibName: String(describing: SectionHeader.self), bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: String(describing: SectionHeader.self))
        
        
    }
    
    // MARK: - CollectionViewCompositionalLayout
//    private func createCompositionalLayout() -> UICollectionViewLayout {
//
//        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
//            let section = self.viewModel.productsList[sectionIndex]
//
//            switch section.section {
//            case .mainMenu:
//                return self.createMainMenuSection()
//            case .specialOffers:
//                return self.createSpecialOfferSection()
//            }
//        }
//        return layout
//    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    
    // MARK: - UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
    
        return cell
    }

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

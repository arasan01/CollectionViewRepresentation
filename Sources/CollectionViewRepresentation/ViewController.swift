import UIKit
import SwiftUI

extension CollectionView {
    public final class ViewController : UIViewController {
        
        var dataSource: UICollectionViewDiffableDataSource<Section, ViewData.ID>! = nil
        var collectionView: UICollectionView! = nil
        weak var coordinator: Coordinator!
        
        init(coordinator: Coordinator) {
            self.coordinator = coordinator
            super.init(nibName: nil, bundle: nil)
            configureCollectionView()
        }
        
        deinit {
            print("CollectionView - ViewController")
        }
        
        required init?(coder: NSCoder) {
            fatalError("In no way is this class related to an interface builder file.")
        }
        
        public override func viewDidLoad() {
            super.viewDidLoad()
            configureHierarchy()
            configureDataSource()
        }
        
        private func configureCollectionView() {
            collectionView = UICollectionView(
                frame: .zero,
                collectionViewLayout: UICollectionViewCompositionalLayout.list(using: .init(appearance: .plain)))
        }
        
        private func configureHierarchy() {
            collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            collectionView.frame = view.bounds
            collectionView.backgroundColor = .systemBackground
            view.addSubview(collectionView)
        }
        
        private func configureDataSource() {
            let cellRegistration = UICollectionView.CellRegistration<CustomConfigurationCell, ViewData> {
                (cell: CustomConfigurationCell, indexPath: IndexPath, data: ViewData) in
                cell.cellContent = self.coordinator.view.content(data)
            }
            
            dataSource = UICollectionViewDiffableDataSource<Section, ViewData.ID>(collectionView: collectionView) {
                (collectionView: UICollectionView, indexPath: IndexPath, dataId: ViewData.ID) -> UICollectionViewCell? in
                return collectionView.dequeueConfiguredReusableCell(
                    using: cellRegistration,
                    for: indexPath,
                    item: self.coordinator.view.collections.first {$0.id == dataId})
            }
            
            // initial data
            var snapshot = NSDiffableDataSourceSnapshot<Section, ViewData.ID>()
            snapshot.appendSections(coordinator.view.collectionSection)
            snapshot.appendItems(coordinator.view.collections.map(\.id))
            dataSource.apply(snapshot, animatingDifferences: false)
        }
    }
}

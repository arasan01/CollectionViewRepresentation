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
        
        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("In no way is this class related to an interface builder file.")
        }
        
        public override func viewDidLoad() {
            super.viewDidLoad()
            configureHierarchy()
            configureDataSource()
        }
        
        public func apply(for newCollections: Collections) {
            var snapshot = NSDiffableDataSourceSnapshot<Section, ViewData.ID>()
            if let apply = coordinator.view.snapshotCustomize {
                snapshot.appendSections(coordinator.view.collectionSection)
                apply(&snapshot, newCollections)
            } else {
                snapshot.appendSections(coordinator.view.collectionSection)
                snapshot.appendItems(coordinator.view.collections.map(\.id))
            }
            dataSource.apply(snapshot, animatingDifferences: true)
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
            let cellRegistration = UICollectionView.CellRegistration<CustomConfigurationCell<CellContent>, ViewData> {
                (cell: CustomConfigurationCell<CellContent>, indexPath: IndexPath, data: ViewData) in
                guard let section = Section(rawValue: indexPath.section) else {
                    cell.cellContent = self.coordinator.view.content(Section(rawValue: 0)!, data)
                    return
                }
                cell.cellContent = self.coordinator.view.content(section, data)
            }
            
            let supplementaryRegistrations = coordinator.view.supplementaryKinds.map { kind in
                UICollectionView.SupplementaryRegistration<CustomSupplementaryView<AnyView>>(
                    elementKind: kind
                ) { (supplementaryView: CustomSupplementaryView<AnyView>, elementKind: String, indexPath: IndexPath) in
                    guard
                        let dataId = self.dataSource.itemIdentifier(for: indexPath),
                        let data = self.coordinator.view.collections.first(where: {$0.id == dataId})
                    else { return }
                    print(data)
                    supplementaryView.cellContent = AnyView(Text("supplementary-\(elementKind), \(indexPath.section)"))
                }
            }
            
            dataSource = UICollectionViewDiffableDataSource<Section, ViewData.ID>(collectionView: collectionView) {
                (collectionView: UICollectionView, indexPath: IndexPath, dataId: ViewData.ID) -> UICollectionViewCell? in
                return collectionView.dequeueConfiguredReusableCell(
                    using: cellRegistration,
                    for: indexPath,
                    item: self.coordinator.view.collections.first {$0.id == dataId})
            }
            
            dataSource.supplementaryViewProvider = {
                (_: UICollectionView, kind: String, index: IndexPath) -> UICollectionReusableView? in
                guard let registrationIndex = self.coordinator.view.supplementaryKinds.firstIndex(of: kind) else { return nil }
                return self.collectionView.dequeueConfiguredReusableSupplementary(
                    using: supplementaryRegistrations[registrationIndex],
                    for: index)
            }
            
            var snapshot = NSDiffableDataSourceSnapshot<Section, ViewData.ID>()
            if let apply = coordinator.view.snapshotCustomize {
                snapshot.appendSections(coordinator.view.collectionSection)
                apply(&snapshot, coordinator.view.collections)
            } else {
                snapshot.appendSections(coordinator.view.collectionSection)
                snapshot.appendItems(coordinator.view.collections.map(\.id))
            }
            dataSource.apply(snapshot, animatingDifferences: false)
        }
    }
}

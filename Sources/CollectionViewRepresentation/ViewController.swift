import UIKit

extension CollectionView {
    public final class ViewController : UIViewController {
        
        var dataSource: UICollectionViewDiffableDataSource<Section, ViewData>! = nil
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
        
        public func apply(for collections: Collections, animatingDifferences: Bool = true) {
            switch (coordinator.view.snapshotCustomize, coordinator.view.sectionSnapshotCustomize) {
            case (let .some(applySnapshot), .none):
                var snapshot = NSDiffableDataSourceSnapshot<Section, ViewData>()
                snapshot.appendSections(coordinator.view.collectionSection)
                applySnapshot(&snapshot, collections)
                dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
                
            case (.none, let .some(applySectionSnapshot)):
                var sections = NSDiffableDataSourceSnapshot<Section, ViewData>()
                sections.appendSections(coordinator.view.collectionSection)
                dataSource.apply(sections, animatingDifferences: false)
                
                var container = Dictionary<Section, NSDiffableDataSourceSectionSnapshot<ViewData>>()
                for section in coordinator.view.collectionSection {
                    container[section] = .init()
                }
                applySectionSnapshot(&container, collections)
                for (section, snapshot) in container {
                    dataSource.apply(snapshot, to: section, animatingDifferences: animatingDifferences)
                }
                
            case (.none, .none):
                var snapshot = NSDiffableDataSourceSnapshot<Section, ViewData>()
                snapshot.appendSections(coordinator.view.collectionSection)
                snapshot.appendItems(Array(collections))
                dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
                
            case (.some, .some):
                fatalError("There must not be two customizers.")
            }
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
                UICollectionView.SupplementaryRegistration<CustomSupplementaryView<SupplementaryContent>>(
                    elementKind: kind
                ) { (supplementaryView: CustomSupplementaryView<SupplementaryContent>, elementKind: String, indexPath: IndexPath) in
                    guard let data = self.dataSource.itemIdentifier(for: indexPath) else { return }
                    supplementaryView.cellContent = self.coordinator.view.supplementaryContent(elementKind, data)
                }
            }
            
            dataSource = UICollectionViewDiffableDataSource<Section, ViewData>(collectionView: collectionView) {
                (collectionView: UICollectionView, indexPath: IndexPath, data: ViewData) -> UICollectionViewCell? in
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: data)
            }
            
            dataSource.supplementaryViewProvider = {
                (_: UICollectionView, kind: String, index: IndexPath) -> UICollectionReusableView? in
                guard let registrationIndex = self.coordinator.view.supplementaryKinds.firstIndex(of: kind) else { return nil }
                return self.collectionView.dequeueConfiguredReusableSupplementary(
                    using: supplementaryRegistrations[registrationIndex],
                    for: index)
            }
            
            apply(for: coordinator.view.collections, animatingDifferences: false)
        }
    }
}

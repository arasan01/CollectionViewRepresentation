import UIKit

extension CollectionView {
    public final class ViewController : UIViewController {
        
        var dataSource: DataSource<Grouping, ViewData>! = nil
        var collectionView: UICollectionView! = nil
        public var repview: CollectionView
        
        init(repview: CollectionView) {
            self.repview = repview
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
            switch (repview.snapshotCustomize, repview.sectionSnapshotCustomize) {
            case (let .some(applySnapshot), .none):
                var snapshot = Snapshot<Grouping, ViewData>()
                snapshot.appendSections(repview.collectionSection)
                applySnapshot(&snapshot, collections)
                dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
                
            case (.none, let .some(applySectionSnapshot)):
                var sections = Snapshot<Grouping, ViewData>()
                sections.appendSections(repview.collectionSection)
                dataSource.apply(sections, animatingDifferences: false)
                
                var container = Dictionary<Grouping, SectionSnapshot<ViewData>>()
                for section in repview.collectionSection {
                    container[section] = .init()
                }
                applySectionSnapshot(&container, collections)
                for (section, snapshot) in container {
                    dataSource.apply(snapshot, to: section, animatingDifferences: animatingDifferences)
                }
                
            case (.none, .none):
                var snapshot = Snapshot<Grouping, ViewData>()
                snapshot.appendSections(repview.collectionSection)
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
            view.addSubview(collectionView)
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: view.topAnchor),
                collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ])
            collectionView.backgroundColor = .systemBackground
        }
        
        private func configureDataSource() {
            let cellRegistration = UICollectionView.CellRegistration<CustomConfigurationCell<CellContent>, ViewData> {
                (cell: CustomConfigurationCell<CellContent>, indexPath: IndexPath, data: ViewData) in
                guard let section = Grouping(rawValue: indexPath.section) else {
                    cell.cellContent = self.repview.content(&self.dataSource, Grouping(rawValue: 0)!, data)
                    return
                }
                cell.cellContent = self.repview.content(&self.dataSource, section, data)
                
            }
            
            let supplementaryRegistrations = repview.supplementaryKinds.map { kind in
                UICollectionView.SupplementaryRegistration<CustomSupplementaryView<SupplementaryContent>>(
                    elementKind: kind
                ) { (supplementaryView: CustomSupplementaryView<SupplementaryContent>, elementKind: String, indexPath: IndexPath) in
                    guard let data = self.dataSource.itemIdentifier(for: indexPath) else { return }
                    supplementaryView.cellContent = self.repview.supplementaryContent(elementKind, data)
                }
            }
            
            dataSource = UICollectionViewDiffableDataSource<Grouping, ViewData>(collectionView: collectionView) {
                (collectionView: UICollectionView, indexPath: IndexPath, data: ViewData) -> UICollectionViewCell? in
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: data)
            }
            
            dataSource.supplementaryViewProvider = {
                (_: UICollectionView, kind: String, index: IndexPath) -> UICollectionReusableView? in
                guard let registrationIndex = self.repview.supplementaryKinds.firstIndex(of: kind) else { return nil }
                return self.collectionView.dequeueConfiguredReusableSupplementary(
                    using: supplementaryRegistrations[registrationIndex],
                    for: index)
            }
            
            apply(for: repview.collections, animatingDifferences: false)
        }
    }
}

import SwiftUI
import UIKit

public typealias Snapshot<S: Sendable & Hashable, T: Sendable & Hashable> = NSDiffableDataSourceSnapshot<S, T>
public typealias SectionSnapshot<T: Sendable & Hashable> = NSDiffableDataSourceSectionSnapshot<T>
public typealias DataSource<S: Sendable & Hashable, T: Sendable & Hashable> = UICollectionViewDiffableDataSource<S, T>

public struct CollectionView<Collections, Grouping, CellContent, SupplementaryContent>
    : UIViewControllerRepresentable
where
    Collections: RandomAccessCollection,
    Collections: Hashable,
    Collections.Index == Int,
    Collections.Element: Hashable,
    Grouping: Hashable,
    Grouping: Sendable,
    Grouping: RawRepresentable,
    Grouping.RawValue == Int,
    CellContent: View,
    SupplementaryContent: View
{
    
    public typealias ViewData = Collections.Element
    public typealias SupplementaryKind = String
    public typealias DiffableContent = (inout DataSource<Grouping, ViewData>, Grouping, ViewData) -> CellContent
    public typealias Content = (Grouping, ViewData) -> CellContent
    public typealias SingleContent = (ViewData) -> CellContent
    public typealias SupplementaryProvider = (SupplementaryKind, ViewData) -> SupplementaryContent
    public typealias SnapshotCustomize = (
        inout Snapshot<Grouping, ViewData>, Collections) -> Void
    public typealias SectionSnapshotCustomize = (
        inout Dictionary<Grouping, SectionSnapshot<ViewData>>, Collections) -> Void
    public typealias RawCustomize = (UICollectionView) -> Void
    
    let collections: Collections
    let content: DiffableContent
    let supplementaryContent: SupplementaryProvider
    let collectionSection: [Grouping]
    let supplementaryKinds: [SupplementaryKind]
    let snapshotCustomize: SnapshotCustomize?
    let sectionSnapshotCustomize: SectionSnapshotCustomize?
    let rawCustomize: RawCustomize?
    let viewLayout: UICollectionViewLayout?
    
    public func makeUIViewController(context: Context) -> ViewController {
        let viewController = ViewController(repview: self)
        return viewController
    }
    
    public func updateUIViewController(_ viewController: ViewController, context: Context) {
        viewController.repview = self
        if let viewLayout = viewLayout {
            viewController.collectionView.collectionViewLayout = viewLayout
        }
        self.rawCustomize?(viewController.collectionView)
        viewController.apply(for: collections)
    }
    
    public init(
        collections: Collections,
        collectionSection: [Grouping],
        supplementaryKinds: [SupplementaryKind],
        viewLayout: UICollectionViewLayout? = nil,
        snapshotCustomize: @escaping SnapshotCustomize,
        rawCustomize: RawCustomize? = nil,
        @ViewBuilder supplementaryContent: @escaping SupplementaryProvider,
        @ViewBuilder content: @escaping DiffableContent
    ) {
        self.collections = collections
        self.viewLayout = viewLayout
        self.rawCustomize = rawCustomize
        self.collectionSection = collectionSection
        self.supplementaryKinds = supplementaryKinds
        self.snapshotCustomize = snapshotCustomize
        self.sectionSnapshotCustomize = nil
        self.supplementaryContent = supplementaryContent
        self.content = content
    }
    
    public init(
        collectionSection: [Grouping],
        collections: Collections,
        supplementaryKinds: [SupplementaryKind],
        viewLayout: UICollectionViewLayout? = nil,
        sectionSnapshotCustomize: @escaping SectionSnapshotCustomize,
        rawCustomize: RawCustomize? = nil,
        @ViewBuilder supplementaryContent: @escaping SupplementaryProvider,
        @ViewBuilder content: @escaping DiffableContent
    ) {
        self.collections = collections
        self.viewLayout = viewLayout
        self.rawCustomize = rawCustomize
        self.collectionSection = collectionSection
        self.supplementaryKinds = supplementaryKinds
        self.snapshotCustomize = nil
        self.sectionSnapshotCustomize = sectionSnapshotCustomize
        self.supplementaryContent = supplementaryContent
        self.content = content
    }
    
    public init(
        collections: Collections,
        collectionSection: [Grouping],
        supplementaryKinds: [SupplementaryKind],
        viewLayout: UICollectionViewLayout? = nil,
        snapshotCustomize: @escaping SnapshotCustomize,
        rawCustomize: RawCustomize? = nil,
        @ViewBuilder supplementaryContent: @escaping SupplementaryProvider,
        @ViewBuilder content: @escaping Content
    ) {
        self.collections = collections
        self.viewLayout = viewLayout
        self.rawCustomize = rawCustomize
        self.collectionSection = collectionSection
        self.supplementaryKinds = supplementaryKinds
        self.snapshotCustomize = snapshotCustomize
        self.sectionSnapshotCustomize = nil
        self.supplementaryContent = supplementaryContent
        self.content = { _, section, data in content(section, data) }
    }
    
    public init(
        collectionSection: [Grouping],
        collections: Collections,
        supplementaryKinds: [SupplementaryKind],
        viewLayout: UICollectionViewLayout? = nil,
        sectionSnapshotCustomize: @escaping  SectionSnapshotCustomize,
        rawCustomize: RawCustomize? = nil,
        @ViewBuilder supplementaryContent: @escaping SupplementaryProvider,
        @ViewBuilder content: @escaping Content
    ) {
        self.collections = collections
        self.viewLayout = viewLayout
        self.rawCustomize = rawCustomize
        self.collectionSection = collectionSection
        self.supplementaryKinds = supplementaryKinds
        self.snapshotCustomize = nil
        self.sectionSnapshotCustomize = sectionSnapshotCustomize
        self.supplementaryContent = supplementaryContent
        self.content = { _, section, data in content(section, data) }
    }
    
    public init(
        collections: Collections,
        collectionSection: [Grouping],
        supplementaryKinds: [SupplementaryKind],
        viewLayout: UICollectionViewLayout? = nil,
        snapshotCustomize: @escaping SnapshotCustomize,
        rawCustomize: RawCustomize? = nil,
        @ViewBuilder supplementaryContent: @escaping SupplementaryProvider,
        @ViewBuilder content: @escaping SingleContent
    ) {
        self.collections = collections
        self.viewLayout = viewLayout
        self.rawCustomize = rawCustomize
        self.collectionSection = collectionSection
        self.supplementaryKinds = supplementaryKinds
        self.snapshotCustomize = snapshotCustomize
        self.sectionSnapshotCustomize = nil
        self.supplementaryContent = supplementaryContent
        self.content = { _, _, data in content(data) }
    }
    
    public init(
        collectionSection: [Grouping],
        collections: Collections,
        supplementaryKinds: [SupplementaryKind],
        viewLayout: UICollectionViewLayout? = nil,
        sectionSnapshotCustomize: @escaping SectionSnapshotCustomize,
        rawCustomize: RawCustomize? = nil,
        @ViewBuilder supplementaryContent: @escaping SupplementaryProvider,
        @ViewBuilder content: @escaping SingleContent
    ) {
        self.collections = collections
        self.viewLayout = viewLayout
        self.rawCustomize = rawCustomize
        self.collectionSection = collectionSection
        self.supplementaryKinds = supplementaryKinds
        self.snapshotCustomize = nil
        self.sectionSnapshotCustomize = sectionSnapshotCustomize
        self.supplementaryContent = supplementaryContent
        self.content = { _, _, data in content(data) }
    }
}

extension CollectionView where Grouping == SingleSection {
    
    public init(
        collections: Collections,
        supplementaryKinds: [SupplementaryKind],
        viewLayout: UICollectionViewLayout? = nil,
        sectionSnapshotCustomize: @escaping SectionSnapshotCustomize,
        rawCustomize: RawCustomize? = nil,
        @ViewBuilder supplementaryContent: @escaping SupplementaryProvider,
        @ViewBuilder content: @escaping DiffableContent
    ) {
        self.collections = collections
        self.viewLayout = viewLayout
        self.rawCustomize = rawCustomize
        self.collectionSection = [SingleSection.main]
        self.supplementaryKinds = supplementaryKinds
        self.snapshotCustomize = nil
        self.sectionSnapshotCustomize = sectionSnapshotCustomize
        self.supplementaryContent = supplementaryContent
        self.content = content
    }
    
    public init(
        collections: Collections,
        supplementaryKinds: [SupplementaryKind],
        viewLayout: UICollectionViewLayout? = nil,
        sectionSnapshotCustomize: @escaping SectionSnapshotCustomize,
        rawCustomize: RawCustomize? = nil,
        @ViewBuilder supplementaryContent: @escaping SupplementaryProvider,
        @ViewBuilder content: @escaping Content
    ) {
        self.collections = collections
        self.viewLayout = viewLayout
        self.rawCustomize = rawCustomize
        self.collectionSection = [SingleSection.main]
        self.supplementaryKinds = supplementaryKinds
        self.snapshotCustomize = nil
        self.sectionSnapshotCustomize = sectionSnapshotCustomize
        self.supplementaryContent = supplementaryContent
        self.content = { _, section, data in content(section, data) }
    }
    
    public init(
        collections: Collections,
        supplementaryKinds: [SupplementaryKind],
        viewLayout: UICollectionViewLayout? = nil,
        rawCustomize: RawCustomize? = nil,
        @ViewBuilder supplementaryContent: @escaping SupplementaryProvider,
        @ViewBuilder content: @escaping SingleContent
    ) {
        self.collections = collections
        self.viewLayout = viewLayout
        self.rawCustomize = rawCustomize
        self.collectionSection = [SingleSection.main]
        self.supplementaryKinds = supplementaryKinds
        self.snapshotCustomize = nil
        self.sectionSnapshotCustomize = nil
        self.supplementaryContent = supplementaryContent
        self.content = { _, _, data in content(data) }
    }
}

extension CollectionView where SupplementaryContent == EmptyView {
    
    public init(
        collectionSection: [Grouping],
        collections: Collections,
        viewLayout: UICollectionViewLayout? = nil,
        sectionSnapshotCustomize: @escaping SectionSnapshotCustomize,
        rawCustomize: RawCustomize? = nil,
        @ViewBuilder content: @escaping DiffableContent
    ) {
        self.collections = collections
        self.viewLayout = viewLayout
        self.rawCustomize = rawCustomize
        self.collectionSection = collectionSection
        self.supplementaryKinds = []
        self.snapshotCustomize = nil
        self.sectionSnapshotCustomize = sectionSnapshotCustomize
        self.supplementaryContent = { _, _ in EmptyView() }
        self.content = content
    }
    
    public init(
        collections: Collections,
        collectionSection: [Grouping],
        viewLayout: UICollectionViewLayout? = nil,
        snapshotCustomize: SnapshotCustomize? = nil,
        rawCustomize: RawCustomize? = nil,
        @ViewBuilder content: @escaping Content
    ) {
        self.collections = collections
        self.viewLayout = viewLayout
        self.rawCustomize = rawCustomize
        self.collectionSection = collectionSection
        self.supplementaryKinds = []
        self.snapshotCustomize = snapshotCustomize
        self.sectionSnapshotCustomize = nil
        self.supplementaryContent = { _, _ in EmptyView() }
        self.content = { _, section, data in content(section, data) }
    }
    
    public init(
        collectionSection: [Grouping],
        collections: Collections,
        viewLayout: UICollectionViewLayout? = nil,
        sectionSnapshotCustomize: @escaping SectionSnapshotCustomize,
        rawCustomize: RawCustomize? = nil,
        @ViewBuilder content: @escaping Content
    ) {
        self.collections = collections
        self.viewLayout = viewLayout
        self.rawCustomize = rawCustomize
        self.collectionSection = collectionSection
        self.supplementaryKinds = []
        self.snapshotCustomize = nil
        self.sectionSnapshotCustomize = sectionSnapshotCustomize
        self.supplementaryContent = { _, _ in EmptyView() }
        self.content = { _, section, data in content(section, data) }
    }
    
    public init(
        collections: Collections,
        collectionSection: [Grouping],
        viewLayout: UICollectionViewLayout? = nil,
        snapshotCustomize: SnapshotCustomize? = nil,
        rawCustomize: RawCustomize? = nil,
        @ViewBuilder content: @escaping SingleContent
    ) {
        self.collections = collections
        self.viewLayout = viewLayout
        self.rawCustomize = rawCustomize
        self.collectionSection = collectionSection
        self.supplementaryKinds = []
        self.snapshotCustomize = snapshotCustomize
        self.sectionSnapshotCustomize = nil
        self.supplementaryContent = { _, _ in EmptyView() }
        self.content = { _, _, data in content(data) }
    }
    
    public init(
        collectionSection: [Grouping],
        collections: Collections,
        viewLayout: UICollectionViewLayout? = nil,
        sectionSnapshotCustomize: @escaping SectionSnapshotCustomize,
        rawCustomize: RawCustomize? = nil,
        @ViewBuilder content: @escaping SingleContent
    ) {
        self.collections = collections
        self.viewLayout = viewLayout
        self.rawCustomize = rawCustomize
        self.collectionSection = collectionSection
        self.supplementaryKinds = []
        self.snapshotCustomize = nil
        self.sectionSnapshotCustomize = sectionSnapshotCustomize
        self.supplementaryContent = { _, _ in EmptyView() }
        self.content = { _, _, data in content(data) }
    }
}

extension CollectionView where SupplementaryContent == EmptyView, Grouping == SingleSection {
    
    public init(
        collections: Collections,
        viewLayout: UICollectionViewLayout? = nil,
        sectionSnapshotCustomize: @escaping SectionSnapshotCustomize,
        rawCustomize: RawCustomize? = nil,
        @ViewBuilder content: @escaping DiffableContent
    ) {
        self.collections = collections
        self.viewLayout = viewLayout
        self.rawCustomize = rawCustomize
        self.collectionSection = [SingleSection.main]
        self.supplementaryKinds = []
        self.snapshotCustomize = nil
        self.sectionSnapshotCustomize = sectionSnapshotCustomize
        self.supplementaryContent = { _, _ in EmptyView() }
        self.content = content
    }
    
    public init(
        collections: Collections,
        viewLayout: UICollectionViewLayout? = nil,
        sectionSnapshotCustomize: @escaping SectionSnapshotCustomize,
        rawCustomize: RawCustomize? = nil,
        @ViewBuilder content: @escaping SingleContent
    ) {
        self.collections = collections
        self.viewLayout = viewLayout
        self.rawCustomize = rawCustomize
        self.collectionSection = [SingleSection.main]
        self.supplementaryKinds = []
        self.snapshotCustomize = nil
        self.sectionSnapshotCustomize = sectionSnapshotCustomize
        self.supplementaryContent = { _, _ in EmptyView() }
        self.content = { _, _, data in content(data) }
    }
    
    public init(
        collections: Collections,
        viewLayout: UICollectionViewLayout? = nil,
        rawCustomize: RawCustomize? = nil,
        @ViewBuilder content: @escaping SingleContent
    ) {
        self.collections = collections
        self.viewLayout = viewLayout
        self.rawCustomize = rawCustomize
        self.collectionSection = [SingleSection.main]
        self.supplementaryKinds = []
        self.snapshotCustomize = nil
        self.sectionSnapshotCustomize = nil
        self.supplementaryContent = { _, _ in EmptyView() }
        self.content = { _, _, data in content(data) }
    }
}

import SwiftUI
import UIKit

public typealias Snapshot<S: Sendable & Hashable, T: Sendable & Hashable> = NSDiffableDataSourceSnapshot<S, T>
public typealias SectionSnapshot<T: Sendable & Hashable> = NSDiffableDataSourceSectionSnapshot<T>

public struct CollectionView<Collections, Section, CellContent, SupplementaryContent>
    : UIViewControllerRepresentable
where
    Collections: RandomAccessCollection,
    Collections: Hashable,
    Collections.Index == Int,
    Collections.Element: Hashable,
    Section: Hashable,
    Section: Sendable,
    Section: RawRepresentable,
    Section.RawValue == Int,
    CellContent: View,
    SupplementaryContent: View
{
    
    public typealias ViewData = Collections.Element
    public typealias SupplementaryKind = String
    public typealias Content = (Section, ViewData) -> CellContent
    public typealias SingleContent = (ViewData) -> CellContent
    public typealias SupplementaryProvider = (SupplementaryKind, ViewData) -> SupplementaryContent
    public typealias SnapshotCustomize = (
        inout Snapshot<Section, ViewData>, Collections) -> Void
    public typealias SectionSnapshotCustomize = (
        inout Dictionary<Section, SectionSnapshot<ViewData>>, Collections) -> Void
    public typealias RawCustomize = (UICollectionView) -> Void
    
    let collections: Collections
    let content: Content
    let supplementaryContent: SupplementaryProvider
    let collectionSection: [Section]
    let supplementaryKinds: [SupplementaryKind]
    let snapshotCustomize: SnapshotCustomize?
    let sectionSnapshotCustomize: SectionSnapshotCustomize?
    let rawCustomize: RawCustomize?
    let viewLayout: UICollectionViewLayout?
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator(view: self)
    }
    
    public func makeUIViewController(context: Context) -> ViewController {
        let coordinator = context.coordinator
        let viewController = ViewController(coordinator: coordinator)
        coordinator.viewController = viewController
        return viewController
    }
    
    public func updateUIViewController(_ viewController: ViewController, context: Context) {
        context.coordinator.view = self
        if let viewLayout = viewLayout {
            viewController.collectionView.collectionViewLayout = viewLayout
        }
        self.rawCustomize?(viewController.collectionView)
        viewController.apply(for: collections)
    }
    
    public init(
        collections: Collections,
        collectionSection: [Section],
        supplementaryKinds: [SupplementaryKind],
        viewLayout: UICollectionViewLayout? = nil,
        snapshotCustomize: SnapshotCustomize? = nil,
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
        self.content = content
    }
    
    public init(
        collections: Collections,
        collectionSection: [Section],
        supplementaryKinds: [SupplementaryKind],
        viewLayout: UICollectionViewLayout? = nil,
        sectionSnapshotCustomize: SectionSnapshotCustomize? = nil,
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
        self.content = content
    }
}

extension CollectionView where Section == SingleSection {
    
    public init(
        collections: Collections,
        supplementaryKinds: [SupplementaryKind],
        viewLayout: UICollectionViewLayout? = nil,
        snapshotCustomize: SnapshotCustomize? = nil,
        rawCustomize: RawCustomize? = nil,
        @ViewBuilder supplementaryContent: @escaping SupplementaryProvider,
        @ViewBuilder content: @escaping Content
    ) {
        self.collections = collections
        self.viewLayout = viewLayout
        self.rawCustomize = rawCustomize
        self.collectionSection = [SingleSection.main]
        self.supplementaryKinds = supplementaryKinds
        self.snapshotCustomize = snapshotCustomize
        self.sectionSnapshotCustomize = nil
        self.supplementaryContent = supplementaryContent
        self.content = content
    }
    
    public init(
        collections: Collections,
        supplementaryKinds: [SupplementaryKind],
        viewLayout: UICollectionViewLayout? = nil,
        sectionSnapshotCustomize: SectionSnapshotCustomize? = nil,
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
        self.content = content
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
        self.content = { (_, data: ViewData) -> CellContent in content(data) }
    }
}

extension CollectionView where SupplementaryContent == EmptyView {
    
    public init(
        collections: Collections,
        collectionSection: [Section],
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
        self.content = content
    }
    
    public init(
        collections: Collections,
        collectionSection: [Section],
        viewLayout: UICollectionViewLayout? = nil,
        sectionSnapshotCustomize: SectionSnapshotCustomize? = nil,
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
        self.content = content
    }
}

extension CollectionView where SupplementaryContent == EmptyView, Section == SingleSection {
    
    public init(
        collections: Collections,
        viewLayout: UICollectionViewLayout? = nil,
        snapshotCustomize: SnapshotCustomize? = nil,
        rawCustomize: RawCustomize? = nil,
        @ViewBuilder content: @escaping SingleContent
    ) {
        self.collections = collections
        self.viewLayout = viewLayout
        self.rawCustomize = rawCustomize
        self.collectionSection = [SingleSection.main]
        self.supplementaryKinds = []
        self.snapshotCustomize = snapshotCustomize
        self.sectionSnapshotCustomize = nil
        self.supplementaryContent = { _, _ in EmptyView() }
        self.content = { (_, data: ViewData) -> CellContent in content(data) }
    }
    
    public init(
        collections: Collections,
        viewLayout: UICollectionViewLayout? = nil,
        sectionSnapshotCustomize: SectionSnapshotCustomize? = nil,
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
        self.content = { (_, data: ViewData) -> CellContent in content(data) }
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
        self.content = { (_, data: ViewData) -> CellContent in content(data) }
    }
}

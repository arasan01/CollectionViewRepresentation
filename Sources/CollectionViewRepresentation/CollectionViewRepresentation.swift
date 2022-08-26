import SwiftUI
import UIKit

public struct CollectionView<Collections, Section, CellContent, SupplementaryContent>
    : UIViewControllerRepresentable
where
    Collections : RandomAccessCollection,
    Collections.Index == Int,
    Collections.Element : Identifiable,
    Section : Hashable,
    Section : Sendable,
    Section : RawRepresentable,
    Section.RawValue == Int,
    CellContent : View,
    SupplementaryContent : View
{
    
    public typealias ViewData = Collections.Element
    public typealias SupplementaryKind = String
    public typealias Content = (Section, ViewData) -> CellContent
    public typealias SupplementaryProvider = (SupplementaryKind, ViewData) -> SupplementaryContent
    public typealias SnapshotCustomize = (
        inout NSDiffableDataSourceSnapshot<Section, ViewData.ID>, Collections) -> Void
    public typealias RawCustomize = (UICollectionView) -> Void
    
    let collections: Collections
    let content: Content
    let supplementaryContent: SupplementaryProvider
    let collectionSection: [Section]
    let supplementaryKinds: [SupplementaryKind]
    let snapshotCustomize: SnapshotCustomize?
    let rawCustomize: RawCustomize?
    let viewLayout: UICollectionViewLayout?
    
    public init(
        collections: Collections,
        collectionSection: [Section],
        supplementaryKinds: [SupplementaryKind],
        viewLayout: UICollectionViewLayout? = nil,
        snapshotCustomize: SnapshotCustomize? = nil,
        rawCustomize: RawCustomize? = nil,
        @ViewBuilder supplementaryContent: @escaping SupplementaryProvider,
        @ViewBuilder content: @escaping Content)
    {
        self.collections = collections
        self.viewLayout = viewLayout
        self.rawCustomize = rawCustomize
        self.collectionSection = collectionSection
        self.supplementaryKinds = supplementaryKinds
        self.snapshotCustomize = snapshotCustomize
        self.supplementaryContent = supplementaryContent
        self.content = content
    }
    
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
        if let viewLayout {
            viewController.collectionView.collectionViewLayout = viewLayout
        }
        self.rawCustomize?(viewController.collectionView)
        viewController.apply(for: collections)
    }
}

extension CollectionView where Section == NonSelectSection {
    
    public init(
        collections: Collections,
        supplementaryKinds: [SupplementaryKind],
        viewLayout: UICollectionViewLayout? = nil,
        snapshotCustomize: SnapshotCustomize? = nil,
        rawCustomize: RawCustomize? = nil,
        @ViewBuilder supplementaryContent: @escaping SupplementaryProvider,
        @ViewBuilder content: @escaping Content)
    {
        self.collections = collections
        self.viewLayout = viewLayout
        self.rawCustomize = rawCustomize
        self.collectionSection = [NonSelectSection.main]
        self.supplementaryKinds = supplementaryKinds
        self.snapshotCustomize = nil
        self.supplementaryContent = supplementaryContent
        self.content = content
    }
}

extension CollectionView where SupplementaryContent == EmptyView {
    
    public init(
        collections: Collections,
        collectionSection: [Section],
        viewLayout: UICollectionViewLayout? = nil,
        snapshotCustomize: SnapshotCustomize? = nil,
        rawCustomize: RawCustomize? = nil,
        @ViewBuilder content: @escaping Content)
    {
        self.collections = collections
        self.viewLayout = viewLayout
        self.rawCustomize = rawCustomize
        self.collectionSection = collectionSection
        self.supplementaryKinds = []
        self.snapshotCustomize = snapshotCustomize
        self.supplementaryContent = { _, _ in
            EmptyView()
        }
        self.content = content
    }
}

extension CollectionView where SupplementaryContent == EmptyView, Section == NonSelectSection {
    
    public init(
        collections: Collections,
        viewLayout: UICollectionViewLayout? = nil,
        rawCustomize: RawCustomize? = nil,
        @ViewBuilder content: @escaping Content)
    {
        self.collections = collections
        self.viewLayout = viewLayout
        self.rawCustomize = rawCustomize
        self.collectionSection = [NonSelectSection.main]
        self.supplementaryKinds = []
        self.snapshotCustomize = nil
        self.supplementaryContent = { _, _ in
            EmptyView()
        }
        self.content = content
    }
}

public enum NonSelectSection: Int {
    case main
}

extension CollectionView {
    
    public final class Coordinator {
        
        var view: CollectionView
        weak var viewController: ViewController?
        
        init(view: CollectionView) {
            self.view = view
        }
    }
}

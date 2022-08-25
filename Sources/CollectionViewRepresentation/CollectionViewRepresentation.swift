import SwiftUI
import UIKit

public struct CollectionView<Collections, Section, CellContent>
    : UIViewControllerRepresentable
where
    Collections : RandomAccessCollection,
    Collections.Index == Int,
    Collections.Element : Identifiable,
    Section : Hashable,
    Section : Sendable,
    Section : RawRepresentable,
    Section.RawValue == Int,
    CellContent : View
{
    
    public typealias ViewData = Collections.Element
    public typealias Content = (Section, ViewData) -> CellContent
    public typealias SnapshotCustomize = (inout NSDiffableDataSourceSnapshot<Section, ViewData.ID>, Collections) -> Void
    public typealias RawCustomize = (UICollectionView) -> Void
    
    let collections: Collections
    let content: Content
    let collectionSection: [Section]
    let snapshotCustomize: SnapshotCustomize?
    let rawCustomize: RawCustomize?
    let viewLayout: UICollectionViewLayout?
    
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
        self.snapshotCustomize = snapshotCustomize
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

extension CollectionView {
    
    public final class Coordinator {
        
        var view: CollectionView
        var viewController: ViewController?
        
        init(view: CollectionView) {
            self.view = view
        }
    }
}

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
    CellContent : View
{
    
    public typealias ViewData = Collections.Element
    public typealias Content = (ViewData) -> CellContent
    public typealias RawCustomize = (UICollectionView) -> Void
    
    let collections: Collections
    let content: Content
    let collectionSection: [Section]
    let rawCustomize: RawCustomize?
    let viewLayout: UICollectionViewLayout?
    
    public init(
        collections: Collections,
        viewLayout: UICollectionViewLayout? = nil,
        rawCustomize: RawCustomize? = nil,
        collectionSection: [Section],
        content: @escaping Content)
    {
        self.collections = collections
        self.viewLayout = viewLayout
        self.rawCustomize = rawCustomize
        self.collectionSection = collectionSection
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
    }
}

extension CollectionView {
    
    public final class Coordinator {
        
        var view: CollectionView
        var viewController: ViewController?
        
        init(view: CollectionView) {
            self.view = view
        }
        
        deinit {
            print("Coordinator")
        }
    }
}

//struct CollectionView_PrewviewProvider: PreviewProvider {
//    static var previews: some View {
//        CollectionView(collections: TextGram.mock) { data in
//            Text("\(data.id): \(data.word), \(data.index)")
//        }
//    }
//}

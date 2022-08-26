extension CollectionView {
    
    public final class Coordinator {
        
        var view: CollectionView
        weak var viewController: ViewController?
        
        init(view: CollectionView) {
            self.view = view
        }
    }
}

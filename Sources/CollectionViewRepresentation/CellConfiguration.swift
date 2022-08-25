import SwiftUI
import UIKit
import UIHostingConfigurationBackport

extension CollectionView {
    
    final class CustomConfigurationCell<Content>: UICollectionViewCell where Content: View {
        
        var cellContent: Content? = nil
        
        override func updateConfiguration(using state: UICellConfigurationState) {
            guard let cellContent = cellContent else { return }
            if #available(iOS 16.0, *) {
                contentConfiguration = UIHostingConfiguration(content: { cellContent }).margins(.all, 0.0).updated(for: state)
            } else {
                contentConfiguration = UIHostingConfigurationBackport(content: { cellContent }).updated(for: state)
            }
        }
    }
    
    final class CustomSupplementaryView<Content>: UICollectionReusableView where Content: View {
        
        private let hostingController: UIHostingController<Content?> = {
            let controller = UIHostingController<Content?>(rootView: nil)
            controller.view.backgroundColor = .clear
            controller.view.translatesAutoresizingMaskIntoConstraints = false
            return controller
        }()
        
        var cellContent: Content? {
            didSet {
                guard let cellContent = cellContent else { return }
                hostingController.rootView = cellContent
            }
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        override init(frame: CGRect) {
            super.init(frame: .zero)
            
            parentViewController?.addChild(hostingController)
            addSubview(hostingController.view)
            hostingController.didMove(toParent: parentViewController)
            NSLayoutConstraint.activate([
                hostingController.view.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
                hostingController.view.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
                hostingController.view.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
                hostingController.view.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            ])
        }
        
        override func didMoveToSuperview() {
            if superview == nil {
                hostingController.willMove(toParent: nil)
                hostingController.removeFromParent()
            } else {
                parentViewController?.addChild(hostingController)
                hostingController.didMove(toParent: parentViewController)
            }
        }
    }
}

private extension UIResponder {
    var parentViewController: UIViewController? {
        return next as? UIViewController ?? next?.parentViewController
    }
}

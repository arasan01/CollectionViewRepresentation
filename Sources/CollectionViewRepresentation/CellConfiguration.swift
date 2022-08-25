import SwiftUI
import UIKit
import UIHostingConfigurationBackport

extension CollectionView {
    
    final class CustomConfigurationCell: UICollectionViewCell {
        
        var cellContent: CellContent? = nil
        
        override func updateConfiguration(using state: UICellConfigurationState) {
            guard let cellContent else {
                return
            }
            if #available(iOS 16.0, *) {
                contentConfiguration = UIHostingConfiguration(content: { cellContent })
            } else {
                contentConfiguration = UIHostingConfigurationBackport(content: { cellContent })
            }
        }
    }
}

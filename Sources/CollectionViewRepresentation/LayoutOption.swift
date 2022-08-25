import UIKit

extension UICollectionViewLayout {
    public static func tagCloud(width: CGFloat = 44, height: CGFloat = 44, config: UICollectionViewCompositionalLayoutConfiguration = .init()) -> UICollectionViewCompositionalLayout {
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let item = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .estimated(width),
                    heightDimension: .fractionalHeight(1.0)))
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(height))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            return section
            
        }, configuration: config)
        return layout
    }
}

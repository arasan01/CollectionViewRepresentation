import SwiftUI
import CollectionViewRepresentation

struct SectionCollectionView: View {
    static func createLayout() -> UICollectionViewLayout {
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let leadingItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.7), heightDimension: .fractionalHeight(1.0))
            )
            
            let trailingItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.3))
            )
            let trailingGroup = NSCollectionLayoutGroup.vertical(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(1.0)),
                                                                 subitem: trailingItem,
                                                                 count: 2)
            
            let containerGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.85),
                                                   heightDimension: .fractionalHeight(0.4)),
                subitems: [leadingItem, trailingGroup])
            let section = NSCollectionLayoutSection(group: containerGroup)
            section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
            return section
            
        }, configuration: config)
        return layout
    }
    
    @State var texts: [TextGram] = TextGram.mock
    
    var body: some View {
        CollectionView(
            collections: texts,
            collectionSection: [Section.main, .sub, .bench],
            viewLayout: Self.createLayout()
        ) { snapshot, collections in
            for data in collections {
                switch Float.random(in: 0...1) {
                case 0..<0.333:
                    snapshot.appendItems([data], toSection: .main)
                case 0.333..<0.666:
                    snapshot.appendItems([data], toSection: .sub)
                case 0.666...1.0:
                    snapshot.appendItems([data], toSection: .bench)
                default:
                    fatalError("logic miss")
                }
            }
        } content: { (section: Section, data: TextGram) in
            switch section {
            case .main:
                Rectangle()
                    .foregroundColor(.orange.opacity(0.7))
                    .padding(8)
                Text(data.word)
                    .foregroundColor(.red)
            case .sub:
                Rectangle()
                    .foregroundColor(.orange.opacity(0.7))
                    .padding(8)
                Text(data.word)
                    .foregroundColor(.green)
            case .bench:
                Rectangle()
                    .foregroundColor(.orange.opacity(0.7))
                    .padding(8)
                Text(data.word)
                    .foregroundColor(.blue)
            }
        }
        .onReceive(Timer.publish(every: refreshTimeInterval, on: .main, in: .common).autoconnect()) { _ in
            self.texts = self.texts.shuffled()
        }
    }
}

struct SectionCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        SectionCollectionView()
    }
}

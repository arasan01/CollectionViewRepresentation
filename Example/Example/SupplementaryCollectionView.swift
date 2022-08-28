import SwiftUI
import CollectionViewRepresentation

struct SupplementaryCollectionView: View {
    static func createLayout() -> UICollectionViewLayout {
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let badgeAnchor = NSCollectionLayoutAnchor(edges: [.top, .trailing], fractionalOffset: CGPoint(x: 0, y: 0))
            let badgeSize = NSCollectionLayoutSize(widthDimension: .absolute(20),
                                                   heightDimension: .absolute(20))
            let badge1 = NSCollectionLayoutSupplementaryItem(
                layoutSize: badgeSize,
                elementKind: Supplementary.badge1.rawValue,
                containerAnchor: badgeAnchor)
            
            let badge2 = NSCollectionLayoutSupplementaryItem(
                layoutSize: badgeSize,
                elementKind: Supplementary.badge2.rawValue,
                containerAnchor: badgeAnchor)
            
            let leadingItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.7), heightDimension: .fractionalHeight(1.0)),
                supplementaryItems: [badge1]
            )
            
            let trailingItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.3)),
                supplementaryItems: [badge2]
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
            
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .estimated(44)),
                elementKind: Supplementary.header.rawValue,
                alignment: .top)
            let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .estimated(44)),
                elementKind: Supplementary.footer.rawValue,
                alignment: .bottom)
            sectionHeader.pinToVisibleBounds = true
            section.boundarySupplementaryItems = [sectionHeader, sectionFooter]
            section.orthogonalScrollingBehavior = .none
            return section
            
        }, configuration: config)
        return layout
    }
    
    @State var texts: [TextGram] = TextGram.mock
    
    var body: some View {
        
        CollectionView(
            collections: texts,
            supplementaryKinds: [
                Supplementary.header.rawValue,
                Supplementary.footer.rawValue,
                Supplementary.badge1.rawValue,
                Supplementary.badge2.rawValue,
            ],
            viewLayout: Self.createLayout()
        ) { kind, data in
            switch Supplementary(rawValue: kind)! {
            case .header, .footer:
                Text("\(kind) - supplementary")
            case .badge1, .badge2:
                ZStack {
                    Capsule()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.red)
                    Text("13")
                        .foregroundColor(.white)
                }
            }
        } content: { (data: TextGram) in
            Rectangle()
                .foregroundColor(.orange.opacity(0.7))
                .padding(8)
            Text(data.word)
                .foregroundColor(.red)
        }
        .onReceive(Timer.publish(every: refreshTimeInterval, on: .main, in: .common).autoconnect()) { _ in
            self.texts = self.texts.shuffled()
        }
    }
}

struct SupplementaryCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        SupplementaryCollectionView()
    }
}

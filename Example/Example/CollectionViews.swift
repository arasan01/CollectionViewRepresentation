//
//  CollectionViews.swift
//  Example
//
//  Created by arasan01 on 2022/08/25.
//

import SwiftUI
import CollectionViewRepresentation

struct CollectionViews: View {
    
    let layout: UICollectionViewLayout?
    
    @State var texts: [TextGram] = TextGram.mock
    
    var body: some View {
        CollectionView(
            collections: texts,
            viewLayout: layout
        ) { (_, data: TextGram) in
            VStack {
                Rectangle()
                    .foregroundColor(.orange.opacity(0.7))
                    .padding(8)
                Text(data.word)
            }
            .background(Color.blue.opacity(0.3))
        }
        .onReceive(Timer.publish(every: 1.5, on: .main, in: .common).autoconnect()) { _ in
            self.texts = self.texts.map({ $0 })
        }
    }
}

struct CollectionViews_Previews: PreviewProvider {
    
    static func createLayout() -> UICollectionViewLayout {
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        
        let layout = UICollectionViewCompositionalLayout(sectionProvider: {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let badgeAnchor = NSCollectionLayoutAnchor(edges: [.top, .trailing], fractionalOffset: CGPoint(x: 0, y: 0))
            let badgeSize = NSCollectionLayoutSize(widthDimension: .absolute(20),
                                                   heightDimension: .absolute(20))

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
    
    static var previews: some View {
        CollectionViews(layout: createLayout())
    }
}

//
//  SimpleCollectionView.swift
//  Example
//
//  Created by arasan01 on 2022/08/25.
//

import SwiftUI
import UIKit
import CollectionViewRepresentation

struct SimpleCollectionView: View {
    
    static func createLayout(behavior: UICollectionLayoutSectionOrthogonalScrollingBehavior) -> UICollectionViewLayout {
        
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
            section.orthogonalScrollingBehavior = behavior
            return section
            
        }, configuration: config)
        return layout
    }
    
    @State var texts: [TextGram] = TextGram.mock
    @State var behaviorState: UICollectionLayoutSectionOrthogonalScrollingBehavior = .continuous
    
    var body: some View {
        Picker("behavior", selection: $behaviorState) {
            Text("none").tag(UICollectionLayoutSectionOrthogonalScrollingBehavior.none)
            Text("continuous").tag(UICollectionLayoutSectionOrthogonalScrollingBehavior.continuous)
            Text("continuousGroupLeadingBoundary").tag(UICollectionLayoutSectionOrthogonalScrollingBehavior.continuousGroupLeadingBoundary)
            Text("paging").tag(UICollectionLayoutSectionOrthogonalScrollingBehavior.paging)
            Text("groupPaging").tag(UICollectionLayoutSectionOrthogonalScrollingBehavior.groupPaging)
            Text("groupPagingCentered").tag(UICollectionLayoutSectionOrthogonalScrollingBehavior.groupPagingCentered)
        }
        .pickerStyle(.menu)
        
        CollectionView(
            collections: texts,
            viewLayout: Self.createLayout(behavior: behaviorState)
        ) { (data: TextGram) in
            VStack {
                Rectangle()
                    .foregroundColor(.orange.opacity(0.7))
                    .padding(8)
                Text(data.word)
            }
            .background(Color.blue.opacity(0.3))
        }
        .onReceive(Timer.publish(every: refreshTimeInterval, on: .main, in: .common).autoconnect()) { _ in
            self.texts = self.texts.map({ $0 })
        }
        Spacer()
    }
}

struct SimpleCollectionView_Previews: PreviewProvider {
    
    static var previews: some View {
        SimpleCollectionView()
    }
}

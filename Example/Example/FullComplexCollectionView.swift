//
//  ContentView.swift
//  Example
//
//  Created by arasan01 on 2022/08/25.
//

import SwiftUI
import CollectionViewRepresentation

struct FullComplexCollectionView: View {
    
    static func createLayout1() -> UICollectionViewLayout {
        
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
            section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
            return section
            
        }, configuration: config)
        return layout
    }
    
    static func createLayout2() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(40),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(80))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 20
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    @State var texts: [TextGram] = TextGram.mock
    @State var segment: SegmentState = .v1
    
    var body: some View {
        Picker("pick", selection: $segment) {
            Text("v1").tag(SegmentState.v1)
            Text("v2").tag(SegmentState.v2)
            Text("v3").tag(SegmentState.v3)
        }.pickerStyle(.segmented)
        
        CollectionView(
            collections: texts,
            collectionSection: [Section.main, .sub, .bench],
            supplementaryKinds: [
                Supplementary.header.rawValue,
                Supplementary.footer.rawValue,
                Supplementary.badge1.rawValue,
                Supplementary.badge2.rawValue,
            ],
            viewLayout: { () -> UICollectionViewLayout in
                switch segment {
                case .v1:
                    return FullComplexCollectionView.createLayout1()
                case .v2:
                    return FullComplexCollectionView.createLayout2()
                case .v3:
                    return UICollectionViewCompositionalLayout.list(using: .init(appearance: .plain))
                }
            }()
        ) { (snapshot: inout NSDiffableDataSourceSnapshot<Section, TextGram.ID>, collections: [TextGram]) in
            for data in collections {
                switch Float.random(in: 0...1) {
                case 0..<0.333:
                    snapshot.appendItems([data.id], toSection: .main)
                case 0.333..<0.666:
                    snapshot.appendItems([data.id], toSection: .sub)
                case 0.666...1.0:
                    snapshot.appendItems([data.id], toSection: .bench)
                default:
                    fatalError("logic miss")
                }
            }
        } supplementaryContent: { (kind: String, data: TextGram) in
            switch Supplementary(rawValue: kind)! {
            case .header, .footer:
                Text("\(kind) - supplementary")
            case .badge1, .badge2:
                ZStack {
                    Capsule()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.red)
                    Text("13")
                        .foregroundColor(.white)
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
                Text(data.word)
                    .foregroundColor(.green)
                Rectangle()
                    .foregroundColor(.orange.opacity(0.7))
                    .padding(8)
            case .bench:
                ZStack {
                    Rectangle()
                        .foregroundColor(.orange.opacity(0.7))
                        .padding(8)
                    Text(data.word)
                        .foregroundColor(.blue)
                }
            }
        }
        .onReceive(Timer.publish(every: refreshTimeInterval, on: .main, in: .common).autoconnect()) { _ in
            self.texts = self.texts.map({ $0 })
        }
        
        Spacer()
    }
}

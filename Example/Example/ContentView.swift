//
//  ContentView.swift
//  Example
//
//  Created by arasan01 on 2022/08/25.
//

import SwiftUI
import CollectionViewRepresentation

struct ContentView: View {
    let layout: UICollectionViewLayout?
    
    var body: some View {
        CollectionView(
            collections: TextGram.mock,
            viewLayout: layout,
            collectionSection: [1,2]
        ) { data in
            Button {
                print(data.word)
            } label: {
                Text("\(data.word)")
                    .padding(4)
                    .background(Color.blue.opacity(0.3))
            }
            .buttonStyle(.plain)
        }
    }
}

struct TextGram: Identifiable {
    var id: UUID = UUID()
    let word: String
    let index: Int
    
    static var mock: [Self] {
        let string = "Learn how to use SwiftUI to compose rich views out of simple ones, set up data flow, and build the navigation while watching it unfold in Xcode’s preview. LongLongLongLongLongLongLongLongLong word"
        return string
            .split(separator: " ")
            .enumerated()
            .map { (index, word) in
                Self(word: String(word), index: index)
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(10),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(44))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    static var previews: some View {
        ContentView(layout: nil)
        
        ContentView(layout: Self.createLayout())
    }
}

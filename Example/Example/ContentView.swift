//
//  ContentView.swift
//  Example
//
//  Created by arasan01 on 2022/08/25.
//

import SwiftUI
import CollectionViewRepresentation

enum Section: Int {
    case main, sub, bench
}

enum Supplementary: String {
    case header, footer, badge1, badge2
}

struct ContentView: View {
    let layout: UICollectionViewLayout?
    
    @State var texts: [TextGram] = TextGram.mock
    
    var body: some View {
        CollectionView(
            collections: texts,
            collectionSection: [Section.main, .sub, .bench],
            supplementaryKinds: [
                Supplementary.header.rawValue,
                Supplementary.footer.rawValue,
                Supplementary.badge1.rawValue,
                Supplementary.badge2.rawValue,
            ],
            viewLayout: layout) { snapshot, collections in
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
                            .frame(width: 20, height: 20)
                            .foregroundColor(.red)
                        Text("13")
                            .foregroundColor(.white)
                    }
                }
            } content: { (section: Section, data: TextGram) in
                switch section {
                case .main:
                    Button {
                        print(data.word)
                    } label: {
                        VStack {
                            Rectangle()
                            Text("\(data.index)")
                            Text("\(data.word)")
                            
                        }
                        .padding(4)
                    }
                    .buttonStyle(.plain)
                case .sub:
                    Button {
                        print(data.word)
                    } label: {
                        VStack {
                            Text("\(data.index)")
                            Rectangle()
                            Text("\(data.word)")
                        }
                        .padding(4)
                    }
                    .buttonStyle(.plain)
                case .bench:
                    Button {
                        print(data.word)
                    } label: {
                        VStack {
                            Text("\(data.index)")
                            Text("\(data.word)")
                            Rectangle()
                        }
                        .padding(4)
                    }
                    .buttonStyle(.plain)
                }
            }
        .onReceive(Timer.publish(every: 1.5, on: .main, in: .common).autoconnect()) { _ in
            self.texts = self.texts.map({ $0 })
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
        
        ContentView(layout: .tagCloud())
    }
}

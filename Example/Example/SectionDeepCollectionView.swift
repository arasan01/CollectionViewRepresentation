import SwiftUI
import UIKit
import CollectionViewRepresentation

struct SectionDeepCollectionView: View {
    
    class OutlineItem: Hashable {
        var id: UUID = UUID()
        let title: String
        let subitems: [OutlineItem]
        
        init(title: String,
             subitems: [OutlineItem] = []) {
            self.title = title
            self.subitems = subitems
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        static func == (lhs: OutlineItem, rhs: OutlineItem) -> Bool {
            return lhs.id == rhs.id
        }
    }
    
    private let menuItems: [OutlineItem] = {
        return [
            OutlineItem(title: "Compositional Layout", subitems: [
                OutlineItem(title: "Getting Started", subitems: [
                    OutlineItem(title: "Grid"),
                    OutlineItem(title: "Inset Items Grid"),
                    OutlineItem(title: "Two-Column Grid"),
                    OutlineItem(title: "Per-Section Layout", subitems: [
                        OutlineItem(title: "Distinct Sections"),
                        OutlineItem(title: "Adaptive Sections")
                    ])
                ]),
                OutlineItem(title: "Advanced Layouts", subitems: [
                    OutlineItem(title: "Supplementary Views", subitems: [
                        OutlineItem(title: "Item Badges"),
                        OutlineItem(title: "Section Headers/Footers"),
                        OutlineItem(title: "Pinned Section Headers")
                    ]),
                    OutlineItem(title: "Section Background Decoration"),
                    OutlineItem(title: "Nested Groups"),
                    OutlineItem(title: "Orthogonal Sections", subitems: [
                        OutlineItem(title: "Orthogonal Sections"),
                        OutlineItem(title: "Orthogonal Section Behaviors")
                    ])
                ]),
                OutlineItem(title: "Conference App", subitems: [
                    OutlineItem(title: "Videos"),
                    OutlineItem(title: "News")
                ])
            ]),
            OutlineItem(title: "Diffable Data Source", subitems: [
                OutlineItem(title: "Mountains Search"),
                OutlineItem(title: "Settings: Wi-Fi"),
                OutlineItem(title: "Insertion Sort Visualization"),
                OutlineItem(title: "UITableView: Editing")
            ]),
            OutlineItem(title: "Lists", subitems: [
                OutlineItem(title: "Simple List"),
                OutlineItem(title: "Reorderable List"),
                OutlineItem(title: "List Appearances"),
                OutlineItem(title: "List with Custom Cells")
            ]),
            OutlineItem(title: "Outlines", subitems: [
                OutlineItem(title: "Emoji Explorer"),
                OutlineItem(title: "Emoji Explorer - List")
            ]),
            OutlineItem(title: "Cell Configurations", subitems: [
                OutlineItem(title: "Custom Configurations")
            ])
        ]
    }()
    
    var body: some View {
        CollectionView(
            collections: menuItems,
            viewLayout: UICollectionViewCompositionalLayout.list(using: .init(appearance: .sidebar))
        ) { (container: inout Dictionary<SingleSection, SectionSnapshot<OutlineItem>>, collections: [OutlineItem]) in
            var snapshot = container[.main]!
            
            func addItems(_ menuItems: [OutlineItem], to parent: OutlineItem?) {
                snapshot.append(menuItems, to: parent)
                for menuItem in menuItems where !menuItem.subitems.isEmpty {
                    addItems(menuItem.subitems, to: menuItem)
                }
            }
            
            addItems(menuItems, to: nil)
        } content: { (data: OutlineItem) in
            Text(data.title)
        }
    }
}

struct SectionDeepCollectionView_Previews: PreviewProvider {
    static var previews: some View {
        SectionDeepCollectionView()
    }
}

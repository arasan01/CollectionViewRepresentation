import Foundation

struct TextGram: Hashable {
    var id: UUID = UUID()
    let word: String
    let index: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
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

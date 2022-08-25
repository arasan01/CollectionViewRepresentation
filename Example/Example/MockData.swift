//
//  MockData.swift
//  Example
//
//  Created by arasan01 on 2022/08/25.
//

import Foundation

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

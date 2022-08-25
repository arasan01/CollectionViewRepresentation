//
//  MetaDescription.swift
//  Example
//
//  Created by arasan01 on 2022/08/25.
//

import Foundation

enum Section: Int {
    case main, sub, bench
}

enum Supplementary: String {
    case header, footer, badge1, badge2
}

enum SegmentState {
    case v1, v2, v3
}

let refreshTimeInterval: TimeInterval = 5.0
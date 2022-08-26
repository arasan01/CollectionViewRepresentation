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

let refreshTimeInterval: TimeInterval = 1.5

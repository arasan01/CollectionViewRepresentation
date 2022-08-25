//
//  OutlineView.swift
//  Example
//
//  Created by arasan01 on 2022/08/26.
//

import SwiftUI

struct OutlineView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink("Simple view", destination: SimpleCollectionView())
                    .padding(8)
                    .background(Color.red.opacity(0.2))
                NavigationLink("Section View", destination: SectionCollectionView())
                    .padding(8)
                    .background(Color.pink.opacity(0.2))
                NavigationLink("Supplementary view", destination: SupplementaryCollectionView())
                    .padding(8)
                    .background(Color.yellow.opacity(0.2))
                NavigationLink("FullComplex view", destination: FullComplexCollectionView())
                    .padding(8)
                    .background(Color.green.opacity(0.2))
            }
        }
    }
}

struct OutlineView_Previews: PreviewProvider {
    static var previews: some View {
        OutlineView()
    }
}

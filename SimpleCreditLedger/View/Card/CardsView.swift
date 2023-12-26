//
//  CardsView.swift
//  SimpleCreditLedger
//
//  Created by Jiaming Guo on 2023-12-25.
//

import SwiftUI

struct CardsView: View {
    let dummyArray: [Int] = Array(repeating: 1, count: 100)
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(dummyArray, id: \.self) {
                    Text("\($0)")
                }
            }
            .navigationTitle("Cards")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    CardsView()
}

//
//  ContentView.swift
//  SimpleCreditLedger
//
//  Created by Jiaming Guo on 2023-12-25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            TabView {
                TransactionsView()
                    .tabItem {
                        Label("Transactions", systemImage: "tablecells.badge.ellipsis")
                    }
                CardsView()
                    .tabItem {
                        Label("Cards", systemImage: "creditcard")
                    }
            }

            GeometryReader { geometry in
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        AddButtonView(action: {
                            
                        })
                        .offset(y: geometry.safeAreaInsets.bottom / 4 )
                        Spacer()
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

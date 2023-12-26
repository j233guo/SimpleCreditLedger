//
//  ContentView.swift
//  SimpleCreditLedger
//
//  Created by Jiaming Guo on 2023-12-25.
//

import SwiftUI

struct ContentView: View {
    @State private var showAddTransactionSheet = false
    
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
                            showAddTransactionSheet = true
                        })
                        .offset(y: geometry.safeAreaInsets.bottom / 4 )
                        Spacer()
                    }
                }
            }
        }
        .sheet(isPresented: $showAddTransactionSheet) {
            AddTransactionView()
        }
    }
}

#Preview {
    ContentView()
}

//
//  CardsView.swift
//  SimpleCreditLedger
//
//  Created by Jiaming Guo on 2023-12-25.
//

import SwiftData
import SwiftUI

struct CardsView: View {
    @State private var showAddCardForm = false
    
    @StateObject private var creditCardViewModel = CreditCardViewModel()
    
    @Query private var cards: [CreditCard]
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(cards) { card in
                        NavigationLink {
                            CardDetailView(card: card)
                        } label: {
                            HStack {
                                CardLogoView(cardType: card.type)
                                Text(card.nickname)
                            }
                        }
                    }
                } footer: {
                    if cards.count == 0 {
                        Text("Currently you do not have a credit card registered.")
                    }
                }
                
                Section {
                    Button("Add a Card") {
                        showAddCardForm = true
                    }
                }
            }
            .navigationTitle("Credit Cards")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showAddCardForm) {
                AddCardView()
            }
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: CreditCard.self, configurations: config)
        return CardsView()
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container")
    }
}

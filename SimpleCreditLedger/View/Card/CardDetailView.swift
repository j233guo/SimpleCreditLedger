//
//  CardDetailView.swift
//  SimpleCreditLedger
//
//  Created by Jiaming Guo on 2023-12-26.
//

import SwiftData
import SwiftUI

struct CardDetailView: View {
    let card: CreditCard
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var showDeleteConfirmation = false
    
    func deleteCard() {
        modelContext.delete(card)
        dismiss()
    }
    
    var body: some View {
        NavigationStack {
            List {
                HStack {
                    CardLogoView(cardType: card.type, size: 60.0)
                    Text(card.nickname)
                        .font(.headline)
                }
                
                Section {
                    Button("Edit Card") {
                        
                    }
                    Button("Remove This Card", role: .destructive) {
                        showDeleteConfirmation = true
                    }
                }
            }
            .navigationTitle("\(card.nickname)")
            .navigationBarTitleDisplayMode(.inline)
        }
        .confirmationDialog("Confirm Delete", isPresented: $showDeleteConfirmation) {
            Button("Confirm Delete", role: .destructive, action: deleteCard)
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: CreditCard.self, configurations: config)
        let example = CreditCard(nickname: "My Amex Card", type: .amex)
        return CardDetailView(card: example)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container")
    }
}

//
//  EditCardView.swift
//  SimpleCreditLedger
//
//  Created by Jiaming Guo on 2023-12-28.
//

import SwiftData
import SwiftUI

struct EditCardView: View {
    var card: CreditCard
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var tempCardNickname: String = "My VISA Card"
    @State private var tempCardType: CardType = .visa
    
    func updateDefaultCardName(for cardType: CardType) {
        func isDefaultName(_ str: String) -> Bool {
            let pattern = "^My\\s.+\\sCard$"
            let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
            return predicate.evaluate(with: str)
        }
        guard isDefaultName(tempCardNickname) else { return }
        tempCardNickname = "My \(tempCardType.rawValue) Card"
    }
    
    func save() {
        card.nickname = tempCardNickname
        card.type = tempCardType
        dismiss()
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Card Network", selection: $tempCardType) {
                        ForEach(CardType.allCases, id: \.self) { type in
                            HStack {
                                CardLogoView(cardType: type)
                                Text(type.rawValue)
                            }.tag(type)
                        }
                    }
                    .pickerStyle(.navigationLink)
                }
                .onChange(of: tempCardType) {
                    updateDefaultCardName(for: tempCardType)
                }
                
                Section {
                    TextField("Enter a Name for the Card", text: $tempCardNickname)
                } header: {
                    Text("Card Nickname")
                } footer: {
                    if tempCardNickname.isEmpty {
                        Text("You must have a name for your card.")
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("Edit Card")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", action: save)
                }
            }
        }
        .onAppear {
            tempCardType = card.type
            tempCardNickname = card.nickname
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: CreditCard.self, configurations: config)
        let example = CreditCard(nickname: "My Amex Card", type: .amex)
        return EditCardView(card: example)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container")
    }
}

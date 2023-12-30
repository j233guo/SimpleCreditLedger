//
//  AddCardView.swift
//  SimpleCreditLedger
//
//  Created by Jiaming Guo on 2023-12-26.
//

import SwiftUI

struct AddCardView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var tempCardNickname: String = "My VISA Card"
    @State private var tempCardType: CardType = .visa
    
    var validateCardName: Bool { tempCardNickname.isEmpty == false }
    
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
        guard validateCardName else { return }
        let newCard = CreditCard(nickname: tempCardNickname, type: tempCardType)
        modelContext.insert(newCard)
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
                    if !validateCardName {
                        Text("You must have a name for your card.")
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("Add a New Card")
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
    }
}

#Preview {
    AddCardView()
}

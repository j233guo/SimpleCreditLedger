//
//  AddCardView.swift
//  SimpleCreditLedger
//
//  Created by Jiaming Guo on 2023-12-26.
//

import SwiftData
import SwiftUI

struct AddCardView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var tempCardNickname: String = "My VISA Card"
    @State private var tempCardType: CardType = .visa
    @State private var tempRewardType: RewardType = .cashback
    @State private var displayDuplicateCardWarning = false
    
    var validateEmptyCardName: Bool { tempCardNickname.isEmpty == false }
    
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
        guard validateEmptyCardName else { return }
        let descriptor = FetchDescriptor<CreditCard>(predicate: #Predicate{ card in
            card.nickname == tempCardNickname
        })
        do {
            let cards = try modelContext.fetch(descriptor)
            if cards.isEmpty {
                let newCard = CreditCard(nickname: tempCardNickname, type: tempCardType, rewardType: tempRewardType)
                modelContext.insert(newCard)
                dismiss()
            } else {
                displayDuplicateCardWarning = true
                return
            }
        } catch {
            print("An error occured when trying to check credit card list.")
        }
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
                    Group {
                        if !validateEmptyCardName {
                            Text("You must have a name for your card.")
                        }
                        if displayDuplicateCardWarning {
                            Text("A card with the same name already exists.")
                        }
                    }
                    .foregroundStyle(.red)
                }
                .onChange(of: tempCardNickname) {
                    displayDuplicateCardWarning = false
                }
                
                Section {
                    Picker("Card Reward Type", selection: $tempRewardType) {
                        ForEach(RewardType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
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

//
//  EditCardView.swift
//  SimpleCreditLedger
//
//  Created by Jiaming Guo on 2023-12-28.
//

import SwiftData
import SwiftUI

fileprivate struct CardRewardsSection: View {
    @Environment(\.modelContext) private var modelContext
    
    @Query private var rewards: [Reward]
    
    init(predicate: Predicate<Reward>) {
        _rewards = Query(filter: predicate)
    }
    
    func removeReward(_ reward: Reward) {
        modelContext.delete(reward)
    }
    
    var body: some View {
        Section {
            ForEach(rewards) { reward in
                HStack {
                    Text("\(reward.category.rawValue)")
                    Spacer()
                    Text("\(formattedRewardMultiplier(reward.type, reward.multiplier))")
                    Text("\(reward.type == .cashback ? "Cashback" : "Point")")
                }
                .contextMenu {
                    Button(role: .destructive) {
                        removeReward(reward)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        } header: {
            Text("Rewards")
        } footer: {
            if rewards.count == 0 {
                Text("You have not registered any reward on this card.")
            }
        }
    }
}

fileprivate struct AddRewardView: View {
    @Binding var expanded: Bool
    @Binding var tempRewardMultiplier: Double
    @Binding var tempRewardCategory: TransactionCategory
    
    let rewardType: RewardType
    
    let addAction: () -> Void
    
    var body: some View {
        if expanded {
            Group {
                Picker("\(rewardType == .cashback ? "Cash Back" : "Point") Multiplier", selection: $tempRewardMultiplier) {
                    ForEach(Array(stride(from: 0, through: 6, by: 0.25)), id: \.self) { number in
                        Text(formattedRewardMultiplier(rewardType, number))
                    }
                }
                Picker("Category", selection: $tempRewardCategory) {
                    ForEach(expenseCategories, id: \.self) { category in
                        Text(category.rawValue)
                            .tag(category)
                    }
                }
                Button {
                    addAction()
                    withAnimation {
                        expanded = false
                    }
                } label: {
                    Text("Add")
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                }
            }
        } else {
            Button {
                expanded = true
            } label: {
                Text("Add a Reward")
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

struct EditCardView: View {
    var card: CreditCard
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    @State private var tempCardNickname: String = "My VISA Card"
    @State private var tempCardType: CardType = .visa
    @State private var tempRewardType: RewardType = .cashback
    @State private var expandAddReward = false
    @State private var tempRewardMultiplier: Double = 1.0
    @State private var tempRewardCategory: TransactionCategory = .misc
    @State private var displayDuplicateCardWarning = false
    
    @Query private var rewards: [Reward]
    
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
    
    func saveCard() {
        guard validateCardName else { return }
        let descriptor = FetchDescriptor<CreditCard>(predicate: #Predicate{ card in
            card.nickname == tempCardNickname
        })
        do {
            let cards = try modelContext.fetch(descriptor)
            if tempCardNickname != card.nickname && !(cards.isEmpty) {
                displayDuplicateCardWarning = true
            } else {
                card.nickname = tempCardNickname
                card.type = tempCardType
                dismiss()
            }
        } catch {
            print("An error occured when trying to check credit card list.")
        }
    }
    
    func saveReward() {
        let newReward = Reward(type: tempRewardType, category: tempRewardCategory, multiplier: tempRewardMultiplier, card: card)
        modelContext.insert(newReward)
        try? modelContext.save()
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
                        if !validateCardName {
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
                
                let cardName = card.nickname
                let rewardPredicate = #Predicate<Reward> { reward in
                    reward.card.nickname == cardName
                }
                CardRewardsSection(predicate: rewardPredicate)
                
                Section {
                    AddRewardView(expanded: $expandAddReward, tempRewardMultiplier: $tempRewardMultiplier, tempRewardCategory: $tempRewardCategory, rewardType: tempRewardType) {
                        saveReward()
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
                    Button("Done", action: saveCard)
                }
            }
        }
        .onAppear {
            tempCardType = card.type
            tempCardNickname = card.nickname
            tempRewardType = card.rewardType
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: CreditCard.self, Reward.self, configurations: config)
        let example = CreditCard(nickname: "My Amex Card", type: .amex, rewardType: .points)
        return EditCardView(card: example)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create model container")
    }
}

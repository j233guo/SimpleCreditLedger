//
//  SimpleCreditLedgerApp.swift
//  SimpleCreditLedger
//
//  Created by Jiaming Guo on 2023-12-25.
//

import SwiftUI
import SwiftData

@main
struct SimpleCreditLedgerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(CreditCardViewModel())
        }
        .modelContainer(for: [Transaction.self, CreditCard.self, Reward.self])
    }
}

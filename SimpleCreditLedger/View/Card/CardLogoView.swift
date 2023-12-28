//
//  CardLogoView.swift
//  SimpleCreditLedger
//
//  Created by Jiaming Guo on 2023-12-26.
//

import SwiftUI

struct CardLogoView: View {
    let cardType: CardType
    var size = 35.0
    
    var body: some View {
        Image("\(cardType.rawValue)")
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .padding(1)
    }
}

#Preview {
    CardLogoView(cardType: .amex)
}

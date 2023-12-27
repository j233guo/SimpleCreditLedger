//
//  AddButtonView.swift
//  SimpleCreditLedger
//
//  Created by Jiaming Guo on 2023-12-25.
//

import SwiftUI

struct AddButtonView: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            action()
        }) {
            Image(systemName: "plus")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .scaleEffect(CGSize(width: 1.5, height: 1.5))
        }
        .frame(width: 60, height: 50)
        .background(Color("AddButtonColor"))
        .cornerRadius(15)
        .shadow(radius: 2, x: 0, y: 3)
        .padding()
    }
}

#Preview {
    AddButtonView(action: {})
}

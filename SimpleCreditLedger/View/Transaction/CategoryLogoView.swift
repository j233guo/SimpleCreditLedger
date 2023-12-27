//
//  CategoryLogoView.swift
//  SimpleCreditLedger
//
//  Created by Jiaming Guo on 2023-12-26.
//

import SwiftUI

struct CategoryLogoView: View {
    let category: TransactionCategory
    var size: CGFloat = 20

    var body: some View {
        Image(systemName: categoryImageName(category))
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size, height: size)
            .padding(size / 5)
            .background(categoryColor(category))
            .clipShape(RoundedRectangle(cornerRadius: size / 5))
            .foregroundColor(.white)
    }
}

#Preview {
    CategoryLogoView(category: .bill)
}

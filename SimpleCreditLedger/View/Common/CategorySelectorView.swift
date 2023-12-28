//
//  CategorySelectorView.swift
//  SimpleCreditLedger
//
//  Created by Jiaming Guo on 2023-12-26.
//

import SwiftUI

struct CategorySelectorTagView: View {
    var category: TransactionCategory
    var selected: Bool
    
    var body: some View {
        ZStack {
            if selected {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.selection)
            }
            VStack {
                Image(systemName: categoryImageName(category))
                    .font(.title)
                    .frame(height: 25)
                Text(category.rawValue)
                    .font(.caption)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
            }
            .padding(10)
            .foregroundStyle(selected ? .white : .primary)
        }
    }
}

struct CategorySelectorView: View {
    let type: TransactionType
    
    @Binding var category: TransactionCategory
    
    func select(_ selectedCategory: TransactionCategory) {
        category = selectedCategory
    }
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: .init(), count: 4), spacing: 10) {
            let categories = type == .income ? incomeCategories : expenseCategories
            ForEach(categories, id: \.self) { item in
                CategorySelectorTagView(category: item, selected: item == category)
                    .onTapGesture { select(item) }
            }
        }
    }
}

#Preview {
    CategorySelectorView(type: .expense, category: Binding(projectedValue: .constant(TransactionCategory.grocery)))
}

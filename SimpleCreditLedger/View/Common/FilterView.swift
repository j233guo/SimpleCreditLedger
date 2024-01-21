//
//  FilterView.swift
//  SimpleCreditLedger
//
//  Created by Jiaming Guo on 2024-01-20.
//

import SwiftUI

struct FilterView: View {
    @Binding var isExpanded: Bool
    @Binding var startDate: Date
    @Binding var endDate: Date

    var body: some View {
        VStack {
            Toggle(isOn: $isExpanded) {
                HStack {
                    Image(systemName: "slider.horizontal.3")
                        .padding(.trailing)
                    Text("Filter")
                }
                .foregroundStyle(.primary)
            }

            if isExpanded {
                DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                DatePicker("End Date", selection: $endDate, displayedComponents: .date)
            }
        }
    }
}

#Preview {
    FilterView(isExpanded: .constant(true), startDate: .constant(.distantPast), endDate: .constant(.distantFuture))
}

//
//  MoviesFilterView.swift
//  LMC
//
//  Created by daniil on 20.09.2024.
//

import SwiftUI

struct MoviesFilterView: View {
    @Environment(\.dismiss) private var dismiss
    @State var isOnYearFilter = false
    @State var isOnRatingFilter = false
    @State private var selectedYear = 2024
    private var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = false
        return formatter
    }
    private let years = Array(1950...2024).reversed()
    private var completionHander: ((MovieFilterDTO) -> Void)?
    
    init(completionHander: (@escaping (MovieFilterDTO) -> Void)) {
        self.completionHander = completionHander
    }
    
    var body: some View {
        ZStack {
            Color.appBlack
                .ignoresSafeArea()
            filterView
        }
        .toolbar {
            backButton
            navigationTitle
        }
        .toolbarBackground(Color.appBlack, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }
        
    private var backButton: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button(action: {
                completionHander?(getFilter())
                dismiss()
            }, label: {
                AppImage(.backward)
                    .foregroundStyle(Color.appWhite)
            })
            
        }
    }
    
    private var navigationTitle: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            //TODO: localize
            Text("Filter")
                .foregroundStyle(Color.appColor)
        }
    }
   
    
    private var filterView: some View {
        VStack(spacing: 20) {
            Toggle(isOn: $isOnYearFilter) {
                Text("Year")
                    .foregroundStyle(Color.appColor)
            }
            .onChange(of: isOnYearFilter) { _, newValue in
                if newValue {
                    isOnRatingFilter = false
                }
            }
            
            if isOnYearFilter {
                Picker("", selection: $selectedYear) {
                    ForEach(years, id: \.self) { year in
                        Text(numberFormatter.string(for: year) ?? year.description)
                            .foregroundStyle(Color.appWhite)
                        
                    }
                }
                .pickerStyle(.wheel)
            }
            Toggle(isOn: $isOnRatingFilter) {
                Text("Rating")
                    .foregroundStyle(Color.appColor)
            }
            .onChange(of: isOnRatingFilter) { _, newValue in
                if newValue {
                    isOnYearFilter = false
                }
            }
            Spacer()
        }
        
        .padding(.horizontal, 16)
    }
    
    private func getFilter() -> MovieFilterDTO {
        if isOnYearFilter {
            return .year(year: selectedYear)
        }
        return .rating
    }
    
}

#Preview {
    MoviesFilterView(completionHander: {res in})
}

//
//  MovieDetailsView.swift
//  LMC
//
//  Created by daniil on 20.09.2024.
//

import SwiftUI
import Kingfisher

struct MovieDetailsView: View {
    @Environment(\.dismiss) private var dismiss
    private let horizontalPadding: CGFloat = 16
    private let movieId: Int
    @StateObject var viewModel = MovieDetailsViewModel()
    
    init(movieId: Int) {
        self.movieId = movieId
    }
    
    var details: MovieDetailsModel {
        return viewModel.details
    }
    
    var body: some View {
        ZStack {
            Color.appBlack
                .ignoresSafeArea()
            if viewModel.isNeedPresentDetails {
                mainView
                    .ignoresSafeArea(edges: .top)
            } else {
                ProgressView()
                    .onAppear(perform: {
                        viewModel.loadDetails(movieId: movieId)
                    })
            }
            
        }
        .toolbar {
            backButton
        }
        
        .toolbarBackground(Color.appBlack, for: .navigationBar)
        .toolbarBackground(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
    }
    
    private var backButton: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button(action: {
                dismiss()
            }, label: {
                AppImage(.backward)
                    .foregroundStyle(Color.appWhite)
            })
            
        }
    }
    
    var mainView: some View {
            ScrollView {
                VStack {
                    headerView
                        .aspectRatio(1, contentMode: .fill)
                    detailsView
                        .padding(.horizontal, horizontalPadding)
                    shotsSection
                        .padding(.horizontal, horizontalPadding)
                        .padding(.top, 20)
                }
            }
    }
    
    var headerView: some View {
        ZStack(alignment: .bottom) {
            if let imageUrl = viewModel.details.coverURL {
                KFImage(imageUrl)
                    .placeholder {
                        ProgressView()
                    }
                    .resizable()
                    .scaledToFit()
            } else {
                Color.appBlack
            }
            nameHStack
                .padding(.horizontal, horizontalPadding)
                .padding(.bottom, 10)
        }
    }
    
    var nameHStack: some View {
        HStack {
            Text(details.name)
                .foregroundStyle(Color.appWhite)
                .font(.system(size: 25))
                .fontWeight(.bold)
            Spacer()
            Text(getRatingText(rating: details.ratingKinopoisk))
                .foregroundStyle(Color.appColor)
                .font(.system(size: 25))
                .fontWeight(.bold)
        }
    }
    
    
    var detailsView: some View {
        VStack(alignment: .leading, spacing: 5) {
            descriptionHStack
            Text(details.description.isEmpty ? AppStrings.noDescription : details.description)
                .opacity(details.description.isEmpty ? 0.5 : 1)
                .foregroundStyle(Color.appWhite)
                .font(.system(size: 17))
                .fontWeight(.semibold)
            Text(details.genres)
                .foregroundStyle(Color.appGray)
                .fontWeight(.bold)
            Text(details.years + details.countries)
                .foregroundStyle(Color.appGray)
                .fontWeight(.bold)
        }
        
        
        
    }
    var descriptionHStack: some View {
        HStack {
            Text(AppStrings.descriptionTitle)
                .foregroundStyle(Color.appWhite)
                .font(.system(size: 30))
                .fontWeight(.bold)
            Spacer()
            if let url = URL(string: details.webUrl) {
                Link(destination: url, label: {
                    AppImage(.link)
                        .foregroundStyle(Color.appColor)
                })
            }
        }
        
    }
    
    var shotsSection: some View {
        VStack(alignment: .leading) {
            if !viewModel.shotLinks.isEmpty {
                Text(AppStrings.shotsTitle)
                    .foregroundStyle(Color.appWhite)
                    .font(.system(size: 30))
                    .fontWeight(.bold)
                shotsScrollView
            } else {
                EmptyView()
            }
        }
    }
    
    var shotsScrollView: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(viewModel.shotLinks, id: \.self) { link in
                    if let shotUrl = URL(string: link) {
                        KFImage(shotUrl)
                            .resizable()
                            .scaledToFit()
                    }
                }
                .frame(width: 150, height: 150)
                
            }
            
        }
        .scrollIndicators(.hidden)

        .frame(height: 100)
    }
    
    private func getRatingText(rating: Double?) -> String {
        guard let rating else {
            return ""
        }
        return String(format: "%.1f", rating)
    }
    
}

#Preview {
    NavigationStack {
        MovieDetailsView(movieId: 77044)
    }
    
}

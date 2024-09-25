//
//  ContentView.swift
//  LMC
//
//  Created by daniil on 19.09.2024.
//

import SwiftUI

struct MoviesView: View {
    @StateObject private var viewModel = MoviesViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBlack
                    .ignoresSafeArea()
                if viewModel.movies.isEmpty {
                    ProgressView()
                } else {
                    moviesScrollView
                }
            }
            .toolbar {
                navigationTitle
                exitButton
            }
            .toolbarBackground(Color.appBlack, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    NavigationStack{
        MoviesView()
    }
}

private extension MoviesView {
    
    var navigationTitle: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text(AppStrings.kinopoiskTitle)
                .foregroundStyle(Color.appColor)
        }
    }
    
    var exitButton: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            
            Button {
                viewModel.handleExitButton()
            } label: {
                AppImage(.exit)
                    .foregroundStyle(Color.appColor)
            }
            
        }
    }
    
    var moviesScrollView: some View {
        ScrollView {
            LazyVStack {
                scrollHeader
                ForEach(viewModel.filteredMovies) { movie in
                    NavigationLink(destination: MovieDetailsView(movieId: movie.kinopoiskID)) {
                        MovieListItemView(listItem: movie)
                    }
                }
                if viewModel.shouldLoadNextPage {
                    ProgressView()
                        .onAppear {
                            viewModel.handleProgressIsPresented()
                        }
                }
            }
            .padding(.horizontal)
        }
        
    }
    
    var scrollHeader: some View {
        HStack {
            NavigationLink(destination: {
                MoviesFilterView() { filter in
                    viewModel.handleNewFilter(filter: filter)
                }
            }) {
                AppImage(.filter)
                    .foregroundColor(Color.appColor)
            }
            searchField
        }
    }
    
    var searchField: some View {
        HStack() {
            Spacer(minLength: 16)
            
            TextField("",
                      text: $viewModel.searchRequest,
                      prompt: Text(AppStrings.searchPlaceholder)
                .foregroundColor(Color.appGray))
            .onChange(of: viewModel.searchRequest, { _, newValue in
                viewModel.handleSearch(newValue)
            })
            .foregroundColor(Color.appWhite)
            
            AppImage(.search)
                .frame(width: 16)
                .foregroundColor(Color.appColor)
                .padding(.trailing, 16)
        }
        .foregroundColor(Color.blue)
        .padding(.vertical)
        .padding(.leading, 5)
        .background {
            Rectangle()
                .border(Color.appGray, width: 2)
                .frame(height: 50)
        }
    }
}

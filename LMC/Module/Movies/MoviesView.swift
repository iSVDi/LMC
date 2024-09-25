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
            //TODO: localize
            Text("KinoPoisk")
                .foregroundStyle(Color.appColor)
        }
    }
    
    var exitButton: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            /* CODEREVIEW:
             Что за TODO? Актуально?
             -- + localization?
             */
            //TODO: move image
            Button {
                viewModel.handleExitButton()
            } label: {
                Image(systemName: "rectangle.portrait.and.arrow.right")
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
                //TODO: move image
                Image(systemName: "slider.vertical.3")
                    .foregroundColor(Color.appColor)
            }
            searchField
        }
    }
    
    //TODO: localize
    //TODO: move image
    var searchField: some View {
        HStack() {
            Spacer(minLength: 16)
            
            TextField("",
                      text: $viewModel.searchRequest,
                      prompt: Text("Keyword")
                .foregroundColor(Color.appGray))
            .onChange(of: viewModel.searchRequest, { _, newValue in
                viewModel.handleSearch(newValue)
            })
            .foregroundColor(Color.appWhite)
            
            Image(systemName: "magnifyingglass")
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

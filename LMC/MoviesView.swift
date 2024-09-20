//
//  ContentView.swift
//  LMC
//
//  Created by daniil on 19.09.2024.
//

import SwiftUI

struct MoviesView: View {
    private let mockData: [MovieListItem] = [
        MovieListItem(title: "BTS: Blood Sweat & Tears", genre: "музыка, короткометражка", year: 2016, country: "Корея Южная", rating: 9.2),
        MovieListItem(title: "Lords of the Lockerroom", genre: "спорт, для взрослых", year: 1999, country: "США", rating: 9.2),
        MovieListItem(title: "Герои Энвелла", genre: "фантастика, мультфильм, детский", year: 2017, country: "Россия", rating: 9.2),
        MovieListItem(title: "Попкульт", genre: "документальный", year: 2022, country: "Россия", rating: 9.2),
        MovieListItem(title: "BTS: Blood Sweat & Tears", genre: "музыка, короткометражка", year: 2016, country: "Корея Южная", rating: 9.2),
        MovieListItem(title: "Lords of the Lockerroom", genre: "спорт, для взрослых", year: 1999, country: "США", rating: 9.2),
        MovieListItem(title: "Герои Энвелла", genre: "фантастика, мультфильм, детский", year: 2017, country: "Россия", rating: 9.2),
        MovieListItem(title: "Попкульт", genre: "документальный", year: 2022, country: "Россия", rating: 9.2),
        MovieListItem(title: "BTS: Blood Sweat & Tears", genre: "музыка, короткометражка", year: 2016, country: "Корея Южная", rating: 9.2),
        MovieListItem(title: "Lords of the Lockerroom", genre: "спорт, для взрослых", year: 1999, country: "США", rating: 9.2),
        MovieListItem(title: "Герои Энвелла", genre: "фантастика, мультфильм, детский", year: 2017, country: "Россия", rating: 9.2),
        MovieListItem(title: "Попкульт", genre: "документальный", year: 2022, country: "Россия", rating: 9.2),
    ]
    
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBlack
                    .ignoresSafeArea()
                moviesScrollView
            }
            .toolbar {
                navigationTitle
                exitButton
                
            }
            .toolbarBackground(Color.appBlack, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
        .navigationBarTitleDisplayMode(.inline)
        
        
    }
    
    private var navigationTitle: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            //TODO: localize
            Text("KinoPoisk")
                .foregroundStyle(Color.appColor)
        }
    }
    
    private var exitButton: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            //TODO: move image
            Image(systemName: "rectangle.portrait.and.arrow.right")
                .foregroundStyle(Color.appColor)
        }
    }
    
    private var moviesScrollView: some View {
        ScrollView {
            LazyVStack {
//                scrollHeader
                ForEach(mockData) { mock in
                    MovieListItemView(mock: mock)
                }
            }
            .padding()
        }
        
    }
    
    private var scrollHeader: some View {
        HStack {
            Image(systemName: "slider.vertical.3")
                .foregroundColor(Color.appColor)
            searhField
        }
    }
    
    //TODO: localize
    //TODO: move image
    private var searhField: some View {
        Rectangle()
            .border(Color.appGray, width: 2)
            .frame(height: 50)
            .overlay {
                HStack() {
                    Spacer(minLength: 16)
                    TextField("",
                              text: $searchText,
                              prompt: Text("Keyword").foregroundColor(Color.appGray))
                    .foregroundColor(Color.appWhite)
                    
                    Image(systemName: "magnifyingglass")
                        .frame(width: 16)
                        .foregroundColor(Color.appColor)
                        .padding(.trailing, 16)
                }
            }
       
    }
    
    
    
    
}


#Preview {
    NavigationStack{
        MoviesView()
    }
}

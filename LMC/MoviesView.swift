//
//  ContentView.swift
//  LMC
//
//  Created by daniil on 19.09.2024.
//

import SwiftUI

struct MoviesView: View {
    let mockData: [MovieListItem] = [
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
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            ScrollView {
                
                LazyVStack {
                    ForEach(mockData) { mock in
                        MovieListView(mock: mock)
                    }
                }
            }
            .padding()
        }
        
        
    }
    
}


#Preview {
    MoviesView()
}

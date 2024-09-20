//
//  MovieListItemView.swift
//  LMC
//
//  Created by daniil on 19.09.2024.
//

import SwiftUI
struct MovieListItemView: View {
    let mock: MovieListItemModel
    private let imageDownloader = MovieImageDownloader()
    
    init(mock: MovieListItemModel) {
        self.mock = mock
    }
    
    var body: some View {
        ZStack {
            Color.black
            HStack {
                if let url = URL(string: mock.posterUrlPreview) {
                    //TODO: implement caching
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                        
                    }
                    .frame(maxWidth: 100, maxHeight: 100)
                }
                VStack(alignment: .leading, spacing: 10) {
                    Text(mock.title)
                        .foregroundStyle(Color.white)
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                    Text(mock.genre)
                        .foregroundStyle(Color.gray)
                        .fontWeight(.bold)
                        .font(.system(size: 15))
                    Text("\(mock.year), " + mock.country)
                        .foregroundStyle(Color.gray)
                        .fontWeight(.bold)
                        .font(.system(size: 15))
                    HStack {
                        Spacer()
                        if let rating = mock.rating {
                            Text("\(rating, specifier: "%.1f")")
                                .foregroundStyle(Color.appColor)
                                .fontWeight(.bold)
                                .font(.system(size: 20))
                        } else {
                            Text("")
                        }
                    }
                    .padding(.trailing)
                    
                }
            }
            
        }
    }
}

struct MovieListView_Preview: PreviewProvider {
    static var previews: some View {
        MovieListItemView(mock: MovieListItemModel(title: "Попкульт",
                                                   genre: "документальный",
                                                   year: 2022,
                                                   country: "Россия",
                                                   rating: 9.2,
                                                   posterUrlPreview: ""))
        .previewLayout(.fixed(width: 300, height: 120))
    }
    
    
}



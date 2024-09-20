//
//  MovieListItemView.swift
//  LMC
//
//  Created by daniil on 19.09.2024.
//

import SwiftUI
struct MovieListItemView: View {
    let mock: MovieListItemModel
    
    init(mock: MovieListItemModel) {
        self.mock = mock
    }
    
    var body: some View {
        ZStack {
            Color.black
            HStack {
                Image("testImage")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 120, maxHeight: 100)
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
                        Text("9.2")
                            .foregroundStyle(Color.appColor)
                            .fontWeight(.bold)
                            .font(.system(size: 20))
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



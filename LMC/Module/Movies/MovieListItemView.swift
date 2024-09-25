//
//  MovieListItemView.swift
//  LMC
//
//  Created by daniil on 19.09.2024.
//

import SwiftUI
import Kingfisher

struct MovieListItemView: View {
    let listItem: MovieListItemModel
    
    init(listItem: MovieListItemModel) {
        self.listItem = listItem
    }
    
    var body: some View {
            HStack {
                if let url = URL(string: listItem.posterUrlPreview) {
                    
                    KFImage(url)
                        .placeholder {
                            ProgressView()
                        }
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 100, maxHeight: 100)
                }
                VStack(alignment: .leading, spacing: 10) {
                    /* CODEREVIEW:
                     Стоит тут добавить лимит по строкам, думаю можно 2 ограничиться
                     Потом эллипс (типа такого многоточия в кон...)
                     */
                    Text(listItem.title)
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                        .foregroundStyle(Color.white)
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                    Text(listItem.genre)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .foregroundStyle(Color.gray)
                        .fontWeight(.bold)
                        .font(.system(size: 15))
                    Text("\(listItem.year), " + listItem.country)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                        .foregroundStyle(Color.gray)
                        .fontWeight(.bold)
                        .font(.system(size: 15))
                    HStack {
                        Spacer()
                        if let rating = listItem.rating {
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
            .background {
                Color.appBlack
            }
    }
}

struct MovieListView_Preview: PreviewProvider {
    static var previews: some View {
        MovieListItemView(
            listItem: MovieListItemModel(
                kinopoiskID: 0,
                title: "Попкульт",
                genre: "документальный",
                year: 2022,
                country: "Россия",
                rating: 9.2,
                posterUrlPreview: ""
            )
        )
        .previewLayout(.fixed(width: 300, height: 120))
    }
}


//
//  MovieListItemView.swift
//  LMC
//
//  Created by daniil on 19.09.2024.
//

import SwiftUI

struct MovieListItemView: View {
    /* CODEREVIEW:
     Почему зовется mock?
     Мок - это "подставные" данные для тестов или пока реальных данных нет
     Тут лучше подходит - listItem или itemData
     */
    let mock: MovieListItemModel
    
    init(mock: MovieListItemModel) {
        self.mock = mock
    }
    
    var body: some View {
        /* CODEREVIEW:
         Ну на основном экране ZStack ок, а тут background вместо ZStack тоже не сработал?
         По идее должен
         */
        ZStack {
            Color.black
            HStack {
                if let url = URL(string: mock.posterUrlPreview) {
                    /* CODEREVIEW:
                     AsyncImage в целом ок, но он не поддерживает кеширование
                     У тебя в изначальной реализации был Kingfisher, у них есть реализация для SUI
                     Можно его тоже сюда затащить
                     */
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
                    /* CODEREVIEW:
                     Стоит тут добавить лимит по строкам, думаю можно 2 ограничиться
                     Потом эллипс (типа такого многоточия в кон...)
                     */
                    Text(mock.title)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(Color.white)
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                    Text(mock.genre)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(Color.gray)
                        .fontWeight(.bold)
                        .font(.system(size: 15))
                    Text("\(mock.year), " + mock.country)
                        .multilineTextAlignment(.leading)
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
        /* CODEREVIEW:
         Переносы) Ты знаешь, что с ними сделать)
         */
        MovieListItemView(mock: MovieListItemModel(kinopoiskID: 0,
                                                   title: "Попкульт",
                                                   genre: "документальный",
                                                   year: 2022,
                                                   country: "Россия",
                                                   rating: 9.2,
                                                   posterUrlPreview: ""))
        .previewLayout(.fixed(width: 300, height: 120))
    }
    
    
}



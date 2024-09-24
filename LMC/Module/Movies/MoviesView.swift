//
//  ContentView.swift
//  LMC
//
//  Created by daniil on 19.09.2024.
//

import SwiftUI

struct MoviesView: View {
    @State private var searchText = ""
    @StateObject private var viewModel = MoviesViewModel()
    /* CODEREVIEW:
     Лайнбрейк после списка свойств
     */
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
                /* CODEREVIEW:
                 Тут не надо лайнбрейка перед закрывающей скобкой
                 */
            }
            .toolbarBackground(Color.appBlack, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
    
    /* CODEREVIEW:
     Можно вынести в приватное расширение, чтобы не писать каждый раз private
     */
    private var navigationTitle: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            //TODO: localize
            Text("KinoPoisk")
                .foregroundStyle(Color.appColor)
        }
    }
    
    private var exitButton: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            /* CODEREVIEW:
             Что за TODO? Актуально?
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
    
    private var moviesScrollView: some View {
        ScrollView {
            LazyVStack {
                scrollHeader
                ForEach(viewModel.filteredMovies) { mock in
                    NavigationLink(destination: MovieDetailsView(movieId: mock.kinopoiskID)) {
                        MovieListItemView(mock: mock)
                            .onAppear {
                                /* CODEREVIEW:
                                 Это можно перенести в onAppear для прогресса, который у тебя ниже
                                 Он показывается как раз для последнего элемента в списке, поэтому
                                 не будет излишних триггеров

                                 И там не придется проверять, что за элемент грузится,
                                 достаточно будет просто проверить на факт прогресса загрузки, чтобы
                                 не триггерить повторно, если уже начали,
                                 */
                                viewModel.handleLastCell(id: mock.id)
                            }
                    }
                }
                if viewModel.isFooterViewPresented {
                    ProgressView()
                }
            }
            .padding(.horizontal)
        }
        
    }
    
    private var scrollHeader: some View {
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
            searhField
        }
    }
    
    //TODO: localize
    //TODO: move image
    private var searhField: some View {
        /* CODEREVIEW:
         На логине была красивее реализована рамка - через паддинг + background. Меньше кода
         Но это так, можешь просто этот коммент удалить :)
         */
        Rectangle()
            .border(Color.appGray, width: 2)
            .frame(height: 50)
            .overlay {
                HStack() {
                    Spacer(minLength: 16)
                    /* CODEREVIEW:
                     Та же история с модификатором foregroundColor - нужно перенести на новую строку
                     */
                    TextField("",
                              text: $searchText,
                              prompt: Text("Keyword").foregroundColor(Color.appGray))
                    .onChange(of: searchText, { _, newValue in
                        viewModel.handleSearch(newValue)
                    })
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

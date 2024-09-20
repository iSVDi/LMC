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
            .navigationBarTitleDisplayMode(.inline)
        }
        
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
            Button(action: {
                print("exit button handler")
            }, label: {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .foregroundStyle(Color.appColor)
            })
            
        }
    }
    
    private var moviesScrollView: some View {
        ScrollView {
            LazyVStack {
                scrollHeader
                ForEach(viewModel.movies) { mock in
                    MovieListItemView(mock: mock)
                }
            }
            .padding(.horizontal)
        }
        
    }
    
    private var scrollHeader: some View {
        HStack {
            Button(action: {
                //TODO: implement
                print("filter button handler ")
            }, label: {
                Image(systemName: "slider.vertical.3")
                    .foregroundColor(Color.appColor)
            })
            
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

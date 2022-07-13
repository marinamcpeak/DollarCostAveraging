//
//  ContentView.swift
//  iOS-DollarCostAveraging
//
//  Created by Marina McPeak on 2022-05-03.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var searchBar: SearchBar = SearchBar()

    var body: some View {
        LoadingView(isShowing: $searchBar.loading) {
            NavigationView {
                GeometryReader { geo in
                    ZStack {
                        Color.white.ignoresSafeArea()
                        if searchBar.mode == .onboarding {
                            onboarding
                                .padding(.bottom, geo.safeAreaInsets.top)
                        }
                        else if let result = searchBar.searchResults {
                            List(result.items, id: \.self) { item in
                                Button {
                                    searchBar.handleSelection(for: item.symbol, searchResult: item)
                                } label: {
                                    SearchResultItemView(result: item)
                                        .background(Color.white)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .listStyle(PlainListStyle())
                        }
                    }
                    .add(self.searchBar)
                    .navigationBarTitle("Search")
                }
            }
        }
    }

    var onboarding: some View {
        VStack(spacing: 24) {
            Image("imLaunch")
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(width: 200)
            Text("Search for companies to calculate potential returns via dollar cost averaging")
                .font(.system(size: 14))
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 24)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


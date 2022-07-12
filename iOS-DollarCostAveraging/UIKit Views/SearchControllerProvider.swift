//
//  SearchBar.swift
//  iOS-DollarCostAveraging
//
//  Created by Marina McPeak on 2022-05-03.
//

import UIKit
import SwiftUI
import Combine

class SearchBar: NSObject, ObservableObject {
    
    enum Mode {
        case onboarding
        case search
    }
    
    @Published var text: String = ""
    @Published var searchResults: SearchResults?
    @Published var loading: Bool = false
    @Published var mode: Mode = .onboarding
    @Published var asset: Asset = Asset()
    @Published var openCalculatorView: Bool = false
    
    lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        sc.delegate = self
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "Enter a company name or symbol"
        sc.searchBar.autocapitalizationType = .allCharacters
        return sc
    }()
    
    private var subscribers = Set<AnyCancellable>()
    private let apiService = APIService()
    
    
    
    override init() {
        super.init()
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchResultsUpdater = self
        self.observeForm()
    }
    
    private func observeForm() {
        $text
            .debounce(for: .milliseconds(750), scheduler: RunLoop.main)
            .sink { [unowned self] (searchQuery) in
                guard !searchQuery.isEmpty else { return }
                self.loading = true
                self.apiService.fetchSymbolsPublisher(keywords: searchQuery).sink { (completion) in
                    self.loading = false
                    switch completion {
                        case .failure(let error):
                            print(error.localizedDescription)
                        case .finished: break
                    }
                } receiveValue: { (searchResults) in
                    self.searchResults = searchResults
                }.store(in: &self.subscribers)
            }.store(in: &subscribers)
    }
    
    func handleSelection(for symbol: String, searchResult: SearchResult) {
        loading = true
        apiService.fetchTimeSeriesMonthlyAdjustedPublisher(keywords: symbol).sink { [weak self] (completionResult) in
            DispatchQueue.main.async {
                self?.loading = false
            }
        } receiveValue: { [weak self] (timeSeriesMonthlyAdjusted) in
            DispatchQueue.main.async {
                self?.loading = false
                self?.asset = Asset(searchResult: searchResult, timeSeriesMonthlyAdjusted: timeSeriesMonthlyAdjusted)
                self?.searchController.searchBar.text = nil
                self?.openCalculatorView = true
            }
        }.store(in: &subscribers)
    }
}

extension SearchBar: UISearchResultsUpdating, UISearchControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchQuery = searchController.searchBar.text,
              !searchQuery.isEmpty else { return }
        self.text = searchQuery
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        mode = .search
    }
    
}


struct SearchBarModifier: ViewModifier {
    
    let searchBar: SearchBar
    
    func body(content: Content) -> some View {
        content
            .overlay(
                ViewControllerResolver { viewController in
                    viewController.navigationItem.searchController = self.searchBar.searchController
                }.frame(width: 0, height: 0)
            )
    }
}

extension View {
    
    func add(_ searchBar: SearchBar) -> some View {
        return self.modifier(SearchBarModifier(searchBar: searchBar))
    }
}

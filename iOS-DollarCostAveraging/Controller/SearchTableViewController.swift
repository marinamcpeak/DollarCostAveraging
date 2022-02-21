//
//  SearchTableViewController.swift
//  iOS-DollarCostAveraging
//
//  Created by Marina McPeak on 2022-02-19.
//

import Combine
import UIKit
import MBProgressHUD

class SearchTableViewController: UITableViewController, UIAnimation {
    
    private enum Mode {
        case onboarding
        case search
    }

    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Enter a company name or symbol"
        searchController.searchBar.autocapitalizationType = .allCharacters
        return searchController
    }()

    private let apiService = APIService()
    private var subscribers = Set<AnyCancellable>()
    private var searchResults: SearchResults?
    @Published private var mode: Mode = .onboarding
    @Published private var searchQuery = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        observeForm()
    }

    private func setupNavigationBar() {
        navigationItem.searchController = searchController
        navigationItem.title = "Search"
    }
    
    private func setupTableView() {
        tableView.tableFooterView = UIView()
    }

    private func observeForm() {
        $searchQuery.debounce(for: .milliseconds(750), scheduler: RunLoop.main)
            .sink { [unowned self] (searchQuery) in
                showLoadingAnimation()
                self.apiService.fetchSymbolsPublisher(keywords: searchQuery)
                    .sink { (completion) in
                        hideLoadingAnimation()
                        switch completion {
                            case .failure(let error):
                                print(error.localizedDescription)
                            case .finished:
                                break
                        }
                    } receiveValue: { (searchResults) in
                        self.searchResults = searchResults
                        self.tableView.reloadData()
                    }
                    .store(in: &self.subscribers)
            }
            .store(in: &subscribers)
        
        $mode.sink { [unowned self] (mode) in
            switch mode {
            case .onboarding:
                self.tableView.backgroundView = SearchPlaceholderView()
            case .search:
                tableView.backgroundView = nil
            }
        }.store(in: &subscribers)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return searchResults?.items.count ?? 0
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    )
        -> UITableViewCell
    {
        let cell =
            tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
            as! SearchTableViewCell
        if let searchResults = self.searchResults {
            let searchResult = searchResults.items[indexPath.row]
            cell.configure(with: searchResult)
        }
        return cell
    }

}

extension SearchTableViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchQuery = searchController.searchBar.text, !searchQuery.isEmpty else {
            return
        }
        self.searchQuery = searchQuery

    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        mode = .search
    }

}

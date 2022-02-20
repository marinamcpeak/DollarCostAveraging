//
//  APIService.swift
//  iOS-DollarCostAveraging
//
//  Created by Marina McPeak on 2022-02-20.
//

import Combine
import Foundation

struct APIService {

  var API_KEY: String {
    return keys.randomElement() ?? ""
  }

  let keys = ["0POAG3980OLQLWIO", "OJF7U42EI57LEAKG", "VQ1XZ2RFS77H60KO"]

  func fetchSymbolsPublisher(keywords: String) -> AnyPublisher<SearchResults, Error> {

    let urlString =
      "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=\(keywords)&apikey=\(API_KEY)"

    let url = URL(string: urlString)!

    return URLSession.shared.dataTaskPublisher(for: url)
      .map({ $0.data })
      .decode(type: SearchResults.self, decoder: JSONDecoder())
      .receive(on: RunLoop.main)
      .eraseToAnyPublisher()
  }

}





//
//  APIService.swift
//  iOS-DollarCostAveraging
//
//  Created by Marina McPeak on 2022-05-03.
//

import Combine
import Foundation

struct APIService {

    var API_KEY: String {
        return keys.randomElement() ?? ""
    }

    let keys = ["N483IC64XUG8M4VQ", "HXMUNDJIX81H2UDJ", "6DUG1TOBABY1SOPG"]

    func fetchSymbolsPublisher(keywords: String) -> AnyPublisher<SearchResults, Error> {

        let result = parseQuery(text: keywords)
        var symbol = String()
        
        /*
         Result Types:
         
         In Objective-C, distinct outcomes from an operation (i.e. success and failure) included both
         a value and an error. For example, calling a completion handler once an operation funished.
         However, when converted this approach to Swift, both the value and error had to be optionals.
         Even if the error argument was `nil`, this created problems because there was no compile-time
         guarantee that the data needed was actually there. The `Result` type addresses this by turning
         success and failure into their own seperate states. A generic result type can be used in many
         different contexts and retains its type safety. In this case, it also allows for proper error
         handling whenever calling the alpha vantage API.
         */
        switch result {
            case .success(let query):
                symbol = query
            case .failure(let error):
                return Fail(error: error).eraseToAnyPublisher()
                /*
                 Combine - Publisher:
                 
                 `.eraseToAnyPublisher()` is an instance method that returns `AnyPublisher`.
                 It wraps the real type so that subscribers only see the generic type. This prevents
                 abstraction across API boundaries.
                 */
        }
        
        // Parsing JSON from URL
        let urlString =
            "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=\(symbol)&apikey=\(API_KEY)"
        let urlResult = parseURL(urlString: urlString)

        // Result Type
        switch urlResult {
            case .success(let url):
                return URLSession.shared.dataTaskPublisher(for: url)
                    .map({ $0.data })
                    .decode(type: SearchResults.self, decoder: JSONDecoder())
                    .receive(on: RunLoop.main)
                    .eraseToAnyPublisher()
            case .failure(let error):
                return Fail(error: error).eraseToAnyPublisher()
        }
    }

    func fetchTimeSeriesMonthlyAdjustedPublisher(
        keywords: String
    ) -> AnyPublisher<TimeSeriesMonthlyAdjusted, Error> {
        
        // Parse keyword query from search
        let result = parseQuery(text: keywords)
        var symbol = String()
        
        // Result Type
        switch result {
            case .success(let query):
                symbol = query
            case .failure(let error):
                // Combine's `Fail` is a [struct] publisher that immediately terminates with an error.
                return Fail(error: error).eraseToAnyPublisher()
        }
        
        // Parsing JSON from URL
        let urlString =
            "https://www.alphavantage.co/query?function=TIME_SERIES_MONTHLY_ADJUSTED&symbol=\(symbol)&apikey=\(API_KEY)"
        let urlResult = parseURL(urlString: urlString)
        
        // Result type
        switch urlResult {
            case .success(let url):
                return URLSession.shared.dataTaskPublisher(for: url)
                    .map({ $0.data })
                    .decode(type: TimeSeriesMonthlyAdjusted.self, decoder: JSONDecoder())
                    .receive(on: RunLoop.main)
                    .eraseToAnyPublisher()
            case .failure(let error):
                return Fail(error: error).eraseToAnyPublisher()
        }
    }

    private func parseQuery(text: String) -> Result<String, Error> {
        // Returns an encoded string with the URL after the first two leading slashes or nil
        if let query = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            return .success(query)
        } else {
            return .failure(APIServiceError.invalidEncoding)
        }
    }

    private func parseURL(urlString: String) -> Result<URL, Error> {
        // Returns URL instance or nil
        if let url = URL(string: urlString) {
            return .success(url)
        } else {
            return .failure(APIServiceError.invalidURL)
        }
    }

}


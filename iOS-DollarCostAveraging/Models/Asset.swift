//
//  Asset.swift
//  iOS-DollarCostAveraging
//
//  Created by Marina McPeak on 2022-05-03.
//

import Foundation

struct Asset {
    let searchResult: SearchResult
    let timeSeriesMonthlyAdjusted: TimeSeriesMonthlyAdjusted

    init() {
        searchResult = SearchResult(symbol: "", name: "", type: "", currency: "")
        timeSeriesMonthlyAdjusted = TimeSeriesMonthlyAdjusted(
            meta: Meta(symbol: ""),
            timeSeries: [:]
        )
    }

    init(
        searchResult: SearchResult,
        timeSeriesMonthlyAdjusted: TimeSeriesMonthlyAdjusted
    ) {
        self.searchResult = searchResult
        self.timeSeriesMonthlyAdjusted = timeSeriesMonthlyAdjusted
    }
}


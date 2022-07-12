//
//  StringExtensions.swift
//  iOS-DollarCostAveraging
//
//  Created by Marina McPeak on 2022-05-03.
//

import Foundation

extension String {

    func addBrackets() -> String {
        return "(\(self))"
    }

    func prefix(withText text: String) -> String {
        return text + self
    }

    func toDouble() -> Double? {
        return Double(self)
    }

}


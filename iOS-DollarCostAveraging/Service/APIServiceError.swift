//
//  APIServiceError.swift
//  iOS-DollarCostAveraging
//
//  Created by Marina McPeak on 2022-07-12.
//

import Foundation

enum APIServiceError: Error {
    case invalidEncoding
    case invalidURL
    case unexpected(code: Int)
}

extension APIServiceError: CustomStringConvertible {
    public var description: String {
        switch self {
            case .invalidEncoding:
                return ""
            case .invalidURL:
                return "A URL instance could not be created from the provided string."
            case .unexpected(_):
                return "An unexpected error occurred."
        }
    }
}

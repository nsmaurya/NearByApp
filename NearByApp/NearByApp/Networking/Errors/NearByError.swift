//
//  NearByError.swift
//  NearByApp
//
//  Created by Sunil Maurya on 25/11/23.
//


import Foundation

enum NearByError: LocalizedError {

    case invalidRequest(error: Error)
    case invalidHttpResponse
    case invalidStatusCode(code: Int)
    case noResponse
    case jsonParseError
    case decodingError(error: Error)
    case apiError(code: Int, message: String)
    case locationDisabled
    case pageEmpty
    case noNetwork
    case noSearchResults(query: String)
    case globalLogout

    var title: String {
        switch self {
        case .pageEmpty:
            return "No Data Found"
        case .noNetwork:
            return "No Internet Connection"
        case .noSearchResults(let query):
            return "No match found for ‘\(query)’"
        case .invalidStatusCode:
            return "Sorry!"
        default:
            return "Oops!"
        }
    }

    var errorDescription: String {
        switch self {
        case let .apiError(_, message):
            return "\(message)"
        case .noNetwork:
            return "Could not connect to internet. Please check your network and try again."
        case .noSearchResults:
            return "We couldn’t find what you are looking for. Check your spelling and try searching again."
        case .pageEmpty:
            return "No data to display"
        case .invalidStatusCode(let statusCode):
            return "Unfortunately our server is down at the moment, please try again after sometime#(\(statusCode))"
        default:
            return "The service is unavailable. Please try after sometime."
        }
    }
}


//
//  VenueEndpoints.swift
//  NearByApp
//
//  Created by Sunil Maurya on 25/11/23.
//


import Foundation
//'?cleint_id=<client_id>&per_page=<it
ems per page>&page=<page number>&lat=<latitude>&lon=<longitude>'
enum VenueEndpoints: Requestable {
    case getVenues(pageNumber: Int, lat: Double, longi: Double, range: String?, queryParam: String?)

    var baseUrl: String { return Constants.baseURL }

    var path: String {
        switch self {
        case .getVenues:
            return "\(baseUrl)2/venues/"
        }
    }

    var params: [String: Any] {
        switch self {
        case .getVenues:
            return ["user": userId]
        }
    }

    var headers: [String: String] {
        switch self {
        case .getVenues:
            return [:]
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getVenues:
            return .get
        }
    }

    var encoding: ParamEncoding {
        switch self {
        case .getVenues:
            return .url
        }
    }

    var enableToken: Bool {
        return true
    }
}

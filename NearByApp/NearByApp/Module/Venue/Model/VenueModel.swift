//
//  VenueModel.swift
//  NearByApp
//
//  Created by Sunil Maurya on 25/11/23.
//

import Foundation

// MARK: - Welcome
struct VenueModel: Codable {
    let venues: [Venue]?
    let meta: Meta?
}

// MARK: - Meta
struct Meta: Codable {
    let total, took, page, perPage: Int?
    let geolocation: Geolocation?

    enum CodingKeys: String, CodingKey {
        case total, took, page
        case perPage = "per_page"
        case geolocation
    }
}

// MARK: - Geolocation
struct Geolocation: Codable {
    let lat, lon: Double?
    let city, state, country, postalCode: String?
    let displayName: String?
    let range: String?

    enum CodingKeys: String, CodingKey {
        case lat, lon, city, state, country
        case postalCode = "postal_code"
        case displayName = "display_name"
        case range
    }
}

// MARK: - Venue
struct Venue: Codable {
    let nameV2, postalCode, name: String?
    let url: String?
    let score: Int
    let location: VenueLocation?
    let address: String?
    let hasUpcomingEvents: Bool?
    let numUpcomingEvents: Int?
    let slug: String?
    let extendedAddress: String?
    let id, popularity: Int?
    let metroCode, capacity: Int?
    let displayLocation: String?

    enum CodingKeys: String, CodingKey {
        case nameV2 = "name_v2"
        case postalCode = "postal_code"
        case name, url, score, location, address
        case hasUpcomingEvents = "has_upcoming_events"
        case numUpcomingEvents = "num_upcoming_events"
        case slug
        case extendedAddress = "extended_address"
        case id, popularity
        case metroCode = "metro_code"
        case capacity
        case displayLocation = "display_location"
    }
}

struct VenueLocation: Codable {
    let lat: Double?
    let lon: Double?
}

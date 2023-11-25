//
//  LocationService.swift
//  NearByApp
//
//  Created by Sunil Maurya on 25/11/23.
//

import Foundation

struct Location: Codable {
    let lattitude: Double
    let longitude: Double

    init(
        lattitude: Double,
        longitude: Double
    ) {
        self.lattitude = lattitude
        self.longitude = longitude
    }
}

protocol LocationService {
    var isLocationServiceEnabled: Bool { get }
    var savedLocation: Location? { get }
    func requestLocation(_ completion: ((Result<Location, Error>) -> Void)?)
    func distanceWithCurrentLocation(_ venueLat: Double, _ venueLongi: Double) -> Double?
}


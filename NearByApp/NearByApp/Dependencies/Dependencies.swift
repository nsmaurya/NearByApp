//
//  Dependencies.swift
//  NearByApp
//
//  Created by Sunil Maurya on 25/11/23.
//

import Foundation

/// Class for Dependency injection
class Dependencies {

    static let shared = Dependencies()

    lazy var apiClient: APIClient = {
        URLSessionAPIClient()
    }()

    lazy var locationService: LocationService = {
        ConcreteLocationService()
    }()

}

//
//  ConcreteLocationService.swift
//  NearByApp
//
//  Created by Sunil Maurya on 25/11/23.
//

import Foundation
import CoreLocation

class ConcreteLocationService: NSObject, LocationService {
    var savedLocation: Location? {
        if let encoded = UserDefaults.standard.object(forKey: "location") as? Data {
            if let location = try? PropertyListDecoder().decode(Location.self, from: encoded) {
                return location
            }
        }
        return nil
    }
    
    // MARK: - Properties
    private var locationCallback: ((Result<Location, Error>) -> Void)?
    private let locationManager: CLLocationManager
    private var allowLocUpdate = true
    
    var isLocationServiceEnabled: Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .denied, .notDetermined, .restricted:
                return false
            case .authorizedAlways, .authorizedWhenInUse:
                return true
            default:
                return false
            }
        } else {
            return false
        }
    }
    
    override init() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 5
        locationManager.pausesLocationUpdatesAutomatically = false
        super.init()
        locationManager.delegate = self
    }
    
    func requestLocation(_ completion: ((Result<Location, Error>) -> Void)?) {
        locationManager.requestWhenInUseAuthorization()
        locationManager.stopUpdatingLocation()
        locationManager.startUpdatingLocation()
        self.locationCallback = completion
    }
    
    func distanceWithCurrentLocation(_ venueLat: Double, _ venueLongi: Double) -> Double? {
        guard let currentLocationLat = savedLocation?.lattitude,
              let currentLocationLongi = savedLocation?.longitude else { return nil }
        let currentLocation = CLLocation(latitude: currentLocationLat, longitude: currentLocationLongi)
        let venueLocation = CLLocation(latitude: venueLat, longitude: venueLongi)
        let distance = Double(round((currentLocation.distance(from: venueLocation) * 0.0006213712) * 100) / 100)
        return distance
    }
}

// MARK: - CLLocationManagerDelegate protocol methods
extension ConcreteLocationService: CLLocationManagerDelegate {

    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        if let newLocation = locations.last {
            var isAllow = false
            if let savedLoc = savedLocation {
                isAllow = fabs(savedLoc.lattitude - newLocation.coordinate.latitude) <= Double.ulpOfOne
                    && fabs(savedLoc.longitude - newLocation.coordinate.longitude) <= Double.ulpOfOne
            }
            if #available(iOS 14.0, *) {
                if manager.accuracyAuthorization == .reducedAccuracy {
                    isAllow = false
                }
            }
            if allowLocUpdate && isAllow == false {
                self.allowLocUpdate = false
                let location = Location(lattitude: newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude)
                self.locationCallback?(.success(location))
            }
        }
    }

    func locationManager(
        _ manager: CLLocationManager,
        didChangeAuthorization status: CLAuthorizationStatus
    ) {
        
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationCallback?(.failure(error))
    }
}

//
//  ViewModel.swift
//  NearByApp
//
//  Created by Sunil Maurya on 25/11/23.
//

import Foundation

class ViewModel {
    
    // MARK: - Success state
    enum State {
        case venueFetched
    }

    // MARK: - Dependencies
    private var apiClient: APIClient {
        Dependencies.shared.apiClient
    }

    private var locationService: LocationService {
        Dependencies.shared.locationService
    }

    //Instances
    private var currentLocation: Location?
    var pageNumber: Int = 1
    var range: Double?
    var queryText: String?
    private(set) var venueModel: VenueModel?
    
    var viewState: ViewState<State> = .empty {
        didSet {
            DispatchQueue.main.async {
                self.onViewStateChange?(self.viewState)
            }
        }
    }
    
    var onViewStateChange: ((_ viewState: ViewState<State>) -> Void)?

    func fetchData() {
        locationService.requestLocation { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .success(let location):
                self.currentLocation = location
                Task {
                    await self.hitAPI()
                }
            case .failure(let error):
                self.viewState = .error(error)
            }
        }
    }
    
    func hitAPI() async {
        let rangeValue: String? = range != nil ? "\(range!)mi" : nil
        let request = VenueEndpoints.getVenues(pageNumber: pageNumber, lat: currentLocation?.lattitude ?? 0, longi: currentLocation?.longitude ?? 0, range: rangeValue, queryParam: queryText)
        do {
            let responseData: DataResponse<VenueModel> = try await apiClient.execute(request: request)
            venueModel = responseData.data
        } catch {
            self.viewState = .error(error)
        }
    }
}

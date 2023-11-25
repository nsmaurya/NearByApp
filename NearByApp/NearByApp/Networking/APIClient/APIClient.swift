//
//  APIClient.swift
//  NearByApp
//
//  Created by Sunil Maurya on 25/11/23.
//

import Foundation

protocol APIClient {
    func cancelRequest(dataTask: DataTask)
    
    func execute<Response: Decodable>(
        request: Requestable
    ) async throws -> DataResponse<Response>
}

extension APIClient {
    func cancelRequest(dataTask: DataTask) {
        dataTask.cancelRequest()
    }
}

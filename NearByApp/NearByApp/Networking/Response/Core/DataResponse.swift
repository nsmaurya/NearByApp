//
//  DataResponse.swift
//  NearByApp
//
//  Created by Sunil Maurya on 25/11/23.
//

import Foundation

class DataResponse<T: Decodable>: Decodable {

    // MARK: - Properties
    let httpCode: Int?
    let error: APIErrorResponse?
    let data: T?
    let success: Bool?

    // MARK: - Helper properties
    var httpResponse: HTTPResponse?
    var httpRequest: Requestable?

    // MARK: - Coding Keys
    private enum CodingKeys: String, CodingKey {
        case httpCode
        case data
        case success
        case error
    }

    required init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: CodingKeys.self)
        httpCode = try? container.decode(Int.self, forKey: .httpCode)
        error    = try? container.decode(APIErrorResponse.self, forKey: .error)
        success  = try? container.decode(Bool.self, forKey: .success)
        data     = try? container.decode(T.self, forKey: .data)
    }

    init(httpCode: Int, error: APIErrorResponse?, data: T?, success: Bool) {
        self.httpCode = httpCode
        self.error = error
        self.data = data
        self.success = success
    }

    func attachRequestResponse(_ request: Requestable, response: HTTPResponse) {
        self.httpResponse = response
        self.httpRequest = request
    }
}

extension DataResponse: CustomDebugStringConvertible {

    var debugDescription: String {

        guard let request = httpRequest, let response = httpResponse else {
            return "Request Could not be printed"
        }

        var output: [String] = []
        output.append("[Request]: \(request)")
        output.append("[Response]: \(response)")
        output.append("[Data]: \(response.data?.count ?? 0) bytes")
        output.append("[Result]: \(String(data: response.data ?? Data(), encoding: .utf8) ?? "No Response")")

        return output.joined(separator: "\n")
    }
}

class EmptyDataResponse: Decodable {

}

class APIErrorResponse: Decodable {

    // MARK: - Properties
    let errorCode: String?
    let errorMessage: String?

    // MARK: - Coding Keys
    private enum CodingKeys: String, CodingKey {
        case errorCode
        case errorMessage
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        errorCode     = try? container.decode(String.self, forKey: .errorCode)
        errorMessage  = try? container.decode(String.self, forKey: .errorMessage)
    }
}

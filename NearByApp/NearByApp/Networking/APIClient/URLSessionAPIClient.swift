//
//  URLSessionAPIClient.swift
//  NearByApp
//
//  Created by Sunil Maurya on 25/11/23.
//

import Foundation

class URLSessionAPIClient: APIClient {

    private func apiErrorDisplayMessage(errMsg: String?, errCode: String?) -> String {
        guard let errorMessage = errMsg, let errorCode = errCode else {
            return NearByError.noResponse.errorDescription
        }
        return "\(errorMessage)#(\(errorCode))"
    }

    private func handleError(_ error: NSError) -> NearByError? {
        switch URLError.Code(rawValue:error.code) {
        case .notConnectedToInternet:
            return .noNetwork
        case .networkConnectionLost:
            return .noNetwork
        case .dataNotAllowed:
            return .noNetwork
        case .secureConnectionFailed:
            return .noNetwork
        default:
            return nil
        }
    }
    
    func execute<Response: Decodable>(
        request: Requestable
    ) async throws -> DataResponse<Response> {

        let decoder: JSONDecoder = JSONDecoder()
        let acceptableStatusCodes: [Int] = Array(200 ..< 299)
        // MARK: - Network Check
        //TODO::
        
        let urlRequest: URLRequest
        do {
            urlRequest = try request.asRequest()
        } catch {
            throw NearByError.invalidRequest(error: error)
        }
        
        let urlSession = URLSession(configuration: .default)
        let (data, response) = try await urlSession.data(for: urlRequest)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NearByError.invalidHttpResponse
        }
        
        // We have the data and response
        let statusCode = httpResponse.statusCode

        if (statusCode == 200 && request.method == .delete) ||
            statusCode == 204
        {//DELETE API STATUS CODE OR Global Logout
            let emptyJSON = "{}"
            do {
                let emptyData = Data(emptyJSON.utf8)
                let dataRes = try decoder.decode(Response.self, from: emptyData)
                let emptyResponse: DataResponse = DataResponse(httpCode: statusCode, error: nil, data: dataRes, success: true)
                return emptyResponse
            } catch {
                throw ShearShareError.decodingError(error: error)
            }
        } //- DELETE API RESPONSE DONE
        
        guard acceptableStatusCodes.contains(statusCode) else {
            // Non success status code. Means it is a error
            let errData = String(data: data, encoding: .utf8) ?? ""
            Logger.log(logLevel: .error, errData)
            do {
                let json = try JSONSerialization.jsonObject(
                    with: data,
                    options: .mutableContainers
                ) as? [String: AnyObject]
                let errorCode = "\(statusCode)"
                let errorMessage = json?["detail"] as? String
                ?? NearByError.invalidHttpResponse.errorDescription
                
                throw NearByError.apiError(
                    code: statusCode,
                    message: self.apiErrorDisplayMessage(errMsg: errorMessage, errCode: errorCode)
                )
            } catch {
                throw NearByError.invalidStatusCode(code: statusCode)
            }
        }
        
        do {
            let dataRes = try decoder.decode(Response.self, from: data)
            let finalResponse = DataResponse(httpCode: statusCode, error: nil, data: dataRes, success: true)
            return finalResponse
        } catch {
            throw NearByError.decodingError(error: error)
        }
    }
}

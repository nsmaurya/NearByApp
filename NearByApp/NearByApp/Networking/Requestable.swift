//
//  Requestable.swift
//  NearByApp
//
//  Created by Sunil Maurya on 25/11/23.
//

import Foundation

enum HTTPMethod: String {
    case get    = "GET"
    case post   = "POST"
    case patch  = "PATCH"
    case delete = "DELETE"
    case put    = "PUT"
}

enum ParamEncoding {
    case url, json, multipart, imageMultipart
}

protocol Requestable {

    // Base Url
    var baseUrl: String { get }

    // Path
    var path: String { get }

    // HTTP method
    var method: HTTPMethod { get }

    // Params are represent as dictionary
    var params: [String: Any] { get }

    // Headers
    var headers: [String: String] { get }

    // Type of encoding to be performed
    var encoding: ParamEncoding { get }

    var enableToken: Bool { get }

}

extension Requestable {

    var baseUrl: String {
        return Constants.ApiEndpoint.baseURL
    }

    func pathWith(version: String, path: String) -> String {
        return "v-" + version + "/" + path
    }

    var enableToken: Bool {
        return false
    }

    func asRequest() throws -> URLRequest {

        // Create a url with base url string
        guard var url = URL(string: baseUrl) else {
            throw RequestError.baseURLInvalid
        }

        url.appendPathComponent(path)
        var urlRequest = URLRequest(url: url)
        var headerValues = headers
        if enableToken,
            let token = Dependencies.shared.userService.getToken() {
            headerValues["Authorization"] = "Bearer \(token)"
        }
        urlRequest.allHTTPHeaderFields = headerValues
        urlRequest.httpMethod = method.rawValue

        Logger.log(logLevel: .info, "#########API URL: \(url.absoluteString )")
        Logger.log(logLevel: .info, "@@@@@@@@@Request Params: \(params)")

        switch encoding {
        case .url:
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
            urlComponents?.queryItems = [URLQueryItem]()
            for (key, value) in params {
                urlComponents?.queryItems?.append(
                    URLQueryItem(name: key, value: "\(value)")
                )
            }
            var finalUrlComponents = urlComponents
            finalUrlComponents?.percentEncodedQuery = urlComponents?.percentEncodedQuery?
                .replacingOccurrences(of: "+", with: "%2B") //for replacing + symbol
            urlRequest.url = finalUrlComponents?.url
        case .json:
            let jsonParams = try JSONSerialization.data(
                withJSONObject: params,
                options: .prettyPrinted
            )
            urlRequest.httpBody = jsonParams
            if url.absoluteString.contains("public/stylist/salonlistings/search/"),
               let pageNumber = params["page"] {

                var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
                urlComponents?.queryItems = [URLQueryItem]()
                urlComponents?.queryItems?.append(
                    URLQueryItem(name: "page", value: "\(pageNumber)")
                )
                urlRequest.url = urlComponents?.url
            }
        case .multipart:
            let param = (params as? [String: String]) ?? [:]
            //try urlRequest.setMultipartFormData(param, encoding: .utf8)

        case .imageMultipart: break
            //try urlRequest.setImageMultipartFormData(params)
        }

        return urlRequest
    }
}

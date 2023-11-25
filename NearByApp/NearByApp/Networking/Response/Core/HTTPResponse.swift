//
//  HTTPResponse.swift
//  NearByApp
//
//  Created by Sunil Maurya on 25/11/23.
//

import Foundation

struct HTTPResponse {

    let statusCode: Int
    let headers: [AnyHashable: Any]
    let data: Data?
}

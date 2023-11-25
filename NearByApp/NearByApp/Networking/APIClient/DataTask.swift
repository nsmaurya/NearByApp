//
//  DataTask.swift
//  NearByApp
//
//  Created by Sunil Maurya on 25/11/23.
//


import Foundation

protocol DataTask {
    func cancelRequest()
}

extension URLSessionDataTask: DataTask {

    func cancelRequest() {
        self.cancel()
    }
}

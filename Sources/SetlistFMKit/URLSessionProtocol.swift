//
//  URLSessionProtocol.swift
//  SetlistFMKit
//
//  Created by Justin Shapiro on 8/29/18.
//  Copyright © 2018 Justin Shapiro. All rights reserved.
//

import Foundation

/// A general-purpose protocol that allows specific networking implementations to be defined
/// in a way that is compatible with `URLSession` so that the providing such network implementation is optional
public protocol URLSessionProtocol {
    func dataTask(with url: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> ()) -> URLSessionDataTaskProtocol
    
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {
    public func dataTask(with url: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> ()) -> URLSessionDataTaskProtocol {
        (dataTask(with: url, completionHandler: completionHandler) as URLSessionDataTask) as URLSessionDataTaskProtocol
    }
    
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    public func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        try await data(for: request, delegate: nil)
    }
}

/// To support the URLSessionProtocol, this is needed since the `resume()` method of URLSessionDataTask
/// cannot be called on a class that simply implements the protocol since `resume()` can't be called on abstract classes
public protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}

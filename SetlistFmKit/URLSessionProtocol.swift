//
//  URLSessionProtocol.swift
//  SetlistFmKit
//
//  Created by Justin Shapiro on 8/29/18.
//  Copyright © 2018 Justin Shapiro. All rights reserved.
//

/// A general-purpose protocol that allows specific networking implementations to be defined
/// in a way that is compatible with `URLSession` so that the providing such network implementation is optional
public protocol URLSessionProtocol {
    func dataTask(with url: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> ()) -> URLSessionDataTaskProtocol
}

extension URLSession: URLSessionProtocol {
    public func dataTask(with url: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> ()) -> URLSessionDataTaskProtocol {
        return (dataTask(with: url, completionHandler: completionHandler) as URLSessionDataTask) as URLSessionDataTaskProtocol
    }
}

/// To support the URLSessionProtocol, this is needed since the `resume()` method of URLSessionDataTask
/// cannot be called on a class that simply implements the protocol since `resume()` can't be called on abstract classes
public protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}

//
//  MockNetwork.swift
//  SetlistFMKitTests
//
//  Created by Justin Shapiro on 8/29/18.
//  Copyright © 2018 Justin Shapiro. All rights reserved.
//

import Foundation
@testable import SetlistFMKit

final class MockNetwork: URLSessionProtocol {
    private var mockFilename: String?
    
    func inject(mock: String) {
        mockFilename = mock
    }
    
    func reset() {
        mockFilename = nil
    }
    
    func dataTask(with url: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> ()) -> URLSessionDataTaskProtocol {
        let (data, response, error) = mockResponse(for: url)
        completionHandler(data, response, error)
        return MockDataTask()
    }
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        let (data, response, _) = mockResponse(for: request)
        
        if let data, let response {
            return (data, response)
        } else {
            throw NSError(domain: "", code: response!.statusCode, userInfo: nil)
        }
    }
    
    private func mockResponse(for urlRequest: URLRequest) -> (Data?, HTTPURLResponse?, Error?) {
        guard let mockFile = mockFilename,
              let path = Bundle.module.path(forResource: mockFile, ofType: "json"),
              let requestUrl = urlRequest.url,
              let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe) 
        else {
            let response = HTTPURLResponse(url: URL(string: "http://www.setlist.fm")!, statusCode: 500, httpVersion: nil, headerFields: nil)
            let error = NSError(domain: "", code: response!.statusCode, userInfo: nil)
            return (nil, response, error as Error)
        }
        
        let response = HTTPURLResponse(url: requestUrl, statusCode: 200, httpVersion: nil, headerFields: nil)
        return (data, response, nil)
    }
}

private final class MockDataTask: URLSessionDataTaskProtocol {
    func resume() {
        // do nothing, this is to satisify the URLSessionDataTask requirements for mocking
    }
}

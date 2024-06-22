//
//  URLSessionProtocolTests.swift
//  SetlistFMKitTests
//
//  Created by Justin Shapiro on 9/10/18.
//  Copyright © 2018 Justin Shapiro. All rights reserved.
//

import XCTest
import Foundation
@testable import SetlistFMKit

final class URLSessionProtocolTests: XCTestCase {
    
    private static var resumeWasCalled: Bool = false
    
    override func setUp() {
        super.setUp()
        URLSessionProtocolTests.resumeWasCalled = false
    }
    
    private final class TestNetwork: URLSessionProtocol {
        func dataTask(with url: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> ()) -> URLSessionDataTaskProtocol {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) { // simulate network latency
                let data = "Hello World!".data(using: .utf8)
                let response = HTTPURLResponse(url: url.url!, statusCode: 200, httpVersion: nil, headerFields: nil)
                
                completionHandler(data, response, nil)
            }
            
            return TestNetworkDataTask()
        }
        
        func data(for request: URLRequest) async throws -> (Data, URLResponse) {
            // simulate network latency
            if #available(iOS 13, *) {
                try await Task.sleep(nanoseconds: 1_700_000_000)
            } else {
                sleep(1)
            }
            
            let data = "Hello World!".data(using: .utf8)
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)
            
            if let data, let response {
                return (data, response)
            } else {
                throw NSError(domain: "", code: response!.statusCode, userInfo: nil)
            }
        }
    }
    
    private final class TestNetworkDataTask: URLSessionDataTaskProtocol {
        func resume() {
            URLSessionProtocolTests.resumeWasCalled = true
        }
    }
    
    func testURLSessionProtocol() {
        let testNetwork = TestNetwork()
        let asyncExpectation = expectation(description: "Test a mock network response using URLSessionProtocol")
        
        let urlRequest = URLRequest(url: URL(string: "www.setlist.fm")!)
        let task = testNetwork.dataTask(with: urlRequest) { data, response, error in
            asyncExpectation.fulfill()
            
            guard let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                error == nil else {
                XCTFail("We expected data and response (200) to be non-nil and error to be nil, but that was not the case")
                return
            }
            
            let string = String(data: data, encoding: .utf8)
            XCTAssert(string == "Hello World!", "We expected the data of the response to be \"Hello World!\", but it was not")
        }
        
        task.resume()
        
        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error, "We expected the mock network call to succeed, but it timed out instead")
        }
    }
    
    func testURLSessionDataTaskProtocol() {
        let testNetwork = TestNetwork()
        let asyncExpectation = expectation(description: "Test a mock network response using URLSessionProtocol")
        
        let urlRequest = URLRequest(url: URL(string: "www.setlist.fm")!)
        let task = testNetwork.dataTask(with: urlRequest) { _, _, _ in
            asyncExpectation.fulfill()
            // do nothing, as this is covered by the previous test
        }
        
        task.resume()
        
        XCTAssertTrue(URLSessionProtocolTests.resumeWasCalled, "We expected that resume was successfully called, but it was not")
        
        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error, "We expected the mock network call to succeed, but it timed out instead")
        }
    }
    
    func testURLSessionInteroperabilityWithProtocol() {
        let url = URL(string: "http://www.setlist.fm")!
        let urlRequest = URLRequest(url: url)
        let asyncExpectation = expectation(description: "Test a real network response using URLSession")
        
        let task = (URLSession.shared as URLSessionProtocol).dataTask(with: urlRequest) { _, _, _ in
            asyncExpectation.fulfill()
        }
        
        task.resume()
        
        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error, "We expected the real network call to succeed, but it timed out instead")
        }
    }
}

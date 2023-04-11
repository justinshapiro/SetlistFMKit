//
//  SetlistFMRequest.swift
//  SetlistFMKit
//
//  Created by Justin Shapiro on 8/11/18.
//  Copyright © 2018 Justin Shapiro. All rights reserved.
//

import Foundation

/// A protocol specifying the required properties of an API-bound request model
protocol SetlistFMRequestModel {
    /// The primary endpoint following the base url, not including any query parameters
    var endpoint: String { get }
    
    /// A dictionary of query parameters that follow the primary components of the endpoint
    var queryParameters: [String: String]? { get }
}

/// Internal helper class of the wrapper which contains a `request` method
/// that enables successful calls to the Setlist.fm API
final class SetlistFMRequest {
    typealias FMError = SetlistFMWrapper.FMError
    typealias SupportedLanguage = SetlistFMWrapper.SupportedLanguage
    private let baseURL: String = "https://api.setlist.fm/rest/1.0/"
    private let apiKey: String
    private let language: SupportedLanguage
    private let session: URLSessionProtocol
    
    /// Initializes a SetlistFMRequest instance with an API key and desired language.
    /// - Parameter apiKey: An valid API key generated from the user's Setlist.fm profile
    /// - Parameter language: The language we set to requests results back in
    /// - Parameter session: The URLSessionProtocol to make network requests through
    init(apiKey: String, language: SupportedLanguage, session: URLSessionProtocol = URLSession.shared) {
        self.apiKey = apiKey
        self.language = language
        self.session = session
    }
    
    /// Executes an HTTP request using an endpoint and parameters defined in a SetlistFMRequestModel
    /// - Parameter model: A model that contains the desired endpoint address and parameters
    /// - Parameter completion: The callback which contains the requested result
    func request<T: Decodable>(_ model: SetlistFMRequestModel, _ completion: @escaping (Result<T, FMError>) -> ()) {
        guard var components = URLComponents(string: model.endpoint) else {
            completion(.failure(.init(code: 0, message: "Provided endpoint is not valid")))
            return
        }
        
        components.queryItems = model.queryParameters?
            .filter { $0.value != "" }
            .map { URLQueryItem(name: $0.key, value: $0.value)}
        
        // web services need the "+" symbol escaped even though it is a valid query parameter character
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        
        let url = URL(string: baseURL + components.url!.absoluteString)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(language.rawValue, forHTTPHeaderField: "Accept-Language")
        
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data,
                let requestResponse = response as? HTTPURLResponse,
                (200 ..< 300) ~= requestResponse.statusCode,
                error == nil
            else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode
                let result = Result<T, FMError>.failure(.init(code: statusCode ?? -1, message: error?.localizedDescription))
                completion(result)
                return
            }
            
            do {
                let data = try JSONDecoder().decode(T.self, from: data)
                completion(Result<T, FMError>.success(data))
            } catch(let error) {
                let result = Result<T, FMError>.failure(.init(code: requestResponse.statusCode, message: error.localizedDescription))
                completion(result)
            }
        }
        
        task.resume()
    }
}

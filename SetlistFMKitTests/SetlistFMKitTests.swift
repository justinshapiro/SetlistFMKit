//
//  SetlistFMKitTests.swift
//  SetlistFMKitTests
//
//  Created by Justin Shapiro on 8/11/18.
//  Copyright © 2018 Justin Shapiro. All rights reserved.
//

import XCTest
@testable import SetlistFMKit

final class SetlistFMKitTests: XCTestCase {
    
    // MARK: - Properties
    
    private var wrapper: SetlistFMWrapper!
    private let mockNetwork = MockNetwork()
    
    // MARK: - Overrides
    
    override func setUp() {
        super.setUp()
        mockNetwork.reset()
        wrapper = SetlistFMWrapper(apiKey: "test-key", language: .english, session: mockNetwork)
    }
    
    // MARK: - Test methods
    
    func testGetArtistWithMbid() {
        let asyncExpectation = expectation(description: "Get data from the artist/{mbid} endpoint")
        
        mockNetwork.inject(mock: "getArtistWithMbid")
        wrapper.getArtist(mbid: "a74b1b7f-71a5-4011-9441-d0b5e4122711") {
            asyncExpectation.fulfill()
            
            if case .success(let artist) = $0 {
                let expectedArtist = FMArtist(mbid: "a74b1b7f-71a5-4011-9441-d0b5e4122711",
                                              tmid: 763468,
                                              name: "Radiohead",
                                              sortName: "Radiohead",
                                              disambiguation: "",
                                              url: "https://www.setlist.fm/setlists/radiohead-bd6bd12.html")
                
                XCTAssert(artist == expectedArtist, "We expected the returned artist to match the expected artist, but it does not")
            } else {
                XCTFail("We expected the call to artist/{mbid} to succeed, but it did not")
            }
        }
        
        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error, "We expected the call to artist/{mbid} to succeed, but it timed out instead")
        }
    }
    
    func testGetArtistWithMbidSetlists() {
        let asyncExpectation = expectation(description: "Get data from the artist/{mbid}/setlists endpoint")
        
        mockNetwork.inject(mock: "getArtistWithMbidSetlists")
        wrapper.getArtistSetlists(mbid: "a74b1b7f-71a5-4011-9441-d0b5e4122711") {
            asyncExpectation.fulfill()
            
            if case .success(let setlistsResponse) = $0 {
                let expectedResponse: Bool = setlistsResponse.setlist?.count == 20 &&
                    setlistsResponse.total == 1145 &&
                    setlistsResponse.page == 1 &&
                    setlistsResponse.itemsPerPage == 20
                XCTAssertTrue(expectedResponse, "We expected the returned setlist response to match the expected setlist response, but it did not")
            } else {
                XCTFail("We expected the call to artist/{mbid}/setlists to succeed, but it did not")
            }
        }
        
        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error, "We expected the call to artist/{mbid}/setlists to succeed, but it timed out instead")
        }
    }
    
    func testGetCityWithGeoId() {
        let asyncExpectation = expectation(description: "Get data from the city/{geoId} endpoint")
        
        mockNetwork.inject(mock: "getCityWithGeoId")
        wrapper.getCity(geoId: "6446330") {
            asyncExpectation.fulfill()
            
            if case .success(let city) = $0 {
                let expectedCity = FMCity(id: "6446330",
                                          name: "Saint-Leu-la-Forêt",
                                          stateCode: "A8",
                                          state: "Île-de-France",
                                          coords: FMCoords(lat: 49.01694, long: 2.24639),
                                          country: FMCountry(code: "FR", name: "France"))
                
                XCTAssert(city == expectedCity, "We expected the returned city to match the expected city, but it did not")
            } else {
                XCTFail("We expected the call to city/{geoId} to succeed, but it did not")
            }
        }
        
        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error, "We expected the call to city/{geoId} to succeed, but it timed out instead")
        }
    }
    
    private enum TestSearchArtistsOption {
        case byName, byTmid
    }
    
    private func testSearchArtists(option: TestSearchArtistsOption) {
        let asyncExpectation = expectation(description: "Get data from the search/artists endpoint")
        let responseHandler: (Result<FMArtistsResult, SetlistFMWrapper.FMError>) -> () = {
            asyncExpectation.fulfill()
            
            if case .success(let artistsResponse) = $0 {
                let expectedResponse: Bool = artistsResponse.artist?.count == 8 &&
                    artistsResponse.itemsPerPage == 30 &&
                    artistsResponse.page == 1 &&
                    artistsResponse.total == 8
                
                XCTAssertTrue(expectedResponse, "We expected the returned artists response to match the expected artists response, but it did not")
            } else {
                XCTFail("We expected the call to search/artists to succeed, but it did not")
            }
        }
        
        mockNetwork.inject(mock: "searchArtists")
        
        switch option {
        case .byName: wrapper.searchArtists(artistName: "Radiohead") { responseHandler($0) }
        case .byTmid: wrapper.searchArtists(artistTmid: 763468)      { responseHandler($0) }
        }
        
        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error, "We expected the call to search/artists to succeed, but it timed out instead")
        }
    }
    
    func testSearchArtistsWithArtistName() {
        testSearchArtists(option: .byName)
    }
    
    func testSearchArtistsWithoutArtistName() {
        testSearchArtists(option: .byTmid)
    }
    
    private enum TestSearchCitiesOption {
        case byName, byCode
    }
    
    private func testSearchCities(option: TestSearchCitiesOption) {
        let asyncExpectation = expectation(description: "Get data from the search/cities endpoint")
        
        let responseHandler: (Result<FMCitiesResult, SetlistFMWrapper.FMError>) -> () = {
            asyncExpectation.fulfill()
            
            if case .success(let citiesResponse) = $0 {
                let expectedResponse: Bool = citiesResponse.cities?.count == 50 &&
                    citiesResponse.total == 154 &&
                    citiesResponse.page == 1 &&
                    citiesResponse.itemsPerPage == 50
                
                XCTAssertTrue(expectedResponse, "We expected the returned cities response to match the expected cities response, but it did not")
            } else {
                XCTFail("We expected the call to search/cities to succeed, but it did not")
            }
        }
        
        
        mockNetwork.inject(mock: "searchCities")
        
        switch option {
        case .byName: wrapper.searchCities(name: "Paris")   { responseHandler($0) }
        case .byCode: wrapper.searchCities(stateCode: "A8") { responseHandler($0) }
        }
        
        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error, "We expected the call to search/cities to succeed, but it timed out instead")
        }
    }
    
    func testSearchCitiesWithCityName() {
        testSearchCities(option: .byName)
    }
    
    func testSearchCitiesWithoutCityName() {
        testSearchCities(option: .byCode)
    }
    
    func testSearchCountries() {
        let asyncExpectation = expectation(description: "Get data from the search/countries endpoint")
        
        mockNetwork.inject(mock: "searchCountries")
        wrapper.searchCountries {
            asyncExpectation.fulfill()
            
            if case .success(let countriesResponse) = $0 {
                let expectedResponse: Bool = countriesResponse.country?.count == 250 &&
                    countriesResponse.itemsPerPage == 250 &&
                    countriesResponse.page == 1 &&
                    countriesResponse.total == 250
                
                XCTAssertTrue(expectedResponse, "We expected the returned countries response to match the expected countries response, but it did not")
            } else {
                XCTFail("We expected the call to search/countries to succeed, but it did not")
            }
        }
        
        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error, "We expected the call to search/countries to succeed, but it timed out instead")
        }
    }
    
    private enum TestSearchSetlistsOption {
        case byName, byTmid
    }
    
    private func testSearchSetlists(option: TestSearchSetlistsOption) {
        let asyncExpectation = expectation(description: "Get data from the search/setlists endpoint")
        let responseHandler: (Result<FMSetlistsResult, SetlistFMWrapper.FMError>) -> () = {
            asyncExpectation.fulfill()
            
            if case .success(let setlistsResponse) = $0 {
                let expectedResponse: Bool = setlistsResponse.setlist?.count == 20 &&
                    setlistsResponse.total == 1145 &&
                    setlistsResponse.page == 4 &&
                    setlistsResponse.itemsPerPage == 20
                
                XCTAssertTrue(expectedResponse, "We expected the returned setlists response to match the expected setlists response, but it did not")
            } else {
                XCTFail("We expected the call to search/setlists to succeed, but it did not")
            }
        }
        
        mockNetwork.inject(mock: "searchSetlists")
        
        switch option {
        case .byName: wrapper.searchSetlists(artistName: "Radiohead", pageNumber: 4) { responseHandler($0) }
        case .byTmid: wrapper.searchSetlists(artistTmid: 763468, pageNumber: 4)      { responseHandler($0) }
        }
        
        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error, "We expected the call to search/setlists to succeed, but it timed out instead")
        }
    }
    
    func testSearchSetlistsWithArtistName() {
        testSearchSetlists(option: .byName)
    }
    
    func testSearchSetlistsWithoutArtistName() {
        testSearchSetlists(option: .byTmid)
    }
    
    private enum TestSearchVenuesOption {
        case byName, byCityName
    }
    
    private func testSearchVenues(option: TestSearchVenuesOption) {
        let asyncExpectation = expectation(description: "Get data from the search/venues endpoint")
        let responseHandler: (Result<FMVenuesResult, SetlistFMWrapper.FMError>) -> () = {
            asyncExpectation.fulfill()
            
            if case .success(let venuesResponse) = $0 {
                let expectedResponse: Bool = venuesResponse.venue?.count == 7 &&
                    venuesResponse.total == 7 &&
                    venuesResponse.page == 1 &&
                    venuesResponse.itemsPerPage == 30
                
                XCTAssertTrue(expectedResponse, "We expected the returned venues response to match the expected venues response, but it did not")
            } else {
                XCTFail("We expected the call to search/venues to succeed, but it did not")
            }
        }
        
        mockNetwork.inject(mock: "searchVenues")
        
        switch option {
        case .byName:     wrapper.searchVenues(name: "Madison Square Garden") { responseHandler($0) }
        case .byCityName: wrapper.searchVenues(cityName: "New York") { responseHandler($0) }
        }
        
        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error, "We expected the call to search/venues to succeed, but it timed out instead")
        }
    }
    
    func testSearchVenuesWithVenueName() {
        testSearchVenues(option: .byName)
    }
    
    func testSearchVenuesWithoutVenueName() {
        testSearchVenues(option: .byCityName)
    }
    
    func testGetSetlistById() {
        let asyncExpectation = expectation(description: "Get data from the setlist/{setlistId} endpoint")
        
        mockNetwork.inject(mock: "getSetlistById")
        wrapper.getSetlist(setlistId: "3bd65058") {
            asyncExpectation.fulfill()
            
            if case .success(let setlist) = $0 {
                let expectedResponse: Bool = setlist.sets?.set?.count == 3 &&
                    setlist.artist?.mbid == "a74b1b7f-71a5-4011-9441-d0b5e4122711"
                
                XCTAssertTrue(expectedResponse, "We expected the returned setlist to match the expected setlist, but it does not")
            } else {
                XCTFail("We expected the call to setlist/{setlistId} to succeed, but it did not")
            }
        }
        
        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error, "We expected the call to setlist/{setlistId} to succeed, but it timed out instead")
        }
    }
    
    func testGetSetlistVersionById() {
        let asyncExpectation = expectation(description: "Get data from the setlist/version/{versionId} endpoint")
        
        mockNetwork.inject(mock: "getSetlistVersionById")
        wrapper.getSetlistVersion(versionId: "13668591") {
            asyncExpectation.fulfill()
            
            if case .success(let setlist) = $0 {
                let expectedResponse: Bool = setlist.sets?.set?.count == 3 &&
                    setlist.artist?.mbid == "a74b1b7f-71a5-4011-9441-d0b5e4122711"
                
                XCTAssertTrue(expectedResponse, "We expected the returned setlist version to match the expected setlist version, but it does not")
            } else {
                XCTFail("We expected the call to setlist/version/{versionId} to succeed, but it did not")
            }
        }
        
        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error, "We expected the call to setlist/version/{versionId} to succeed, but it timed out instead")
        }
    }
    
    func testGetUserById() {
        let asyncExpectation = expectation(description: "Get data from the user/{userId} endpoint")
        
        mockNetwork.inject(mock: "getUserById")
        wrapper.getUser(userId: "gloryfades") {
            asyncExpectation.fulfill()
            
            if case .success(let user) = $0 {
                let expectedUser = FMUser(userId: "gloryfades",
                                          fullname: "Justin",
                                          lastFM: nil,
                                          mySpace: nil,
                                          twitter: nil,
                                          fickr: nil,
                                          website: nil,
                                          about: nil,
                                          url: "https://www.setlist.fm/user/gloryfades")
                
                XCTAssert(user == expectedUser, "We expected the returned user to match the expected user, but it does not")
            } else {
                XCTFail("We expected the call to user/{userId} to succeed, but it did not")
            }
        }
        
        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error, "We expected the call to user/{userId} to succeed, but it timed out instead")
        }
    }
    
    func testGetUserAttendedSetlists() {
        let asyncExpectation = expectation(description: "Get data from the user/{userId}/attended endpoint")
        
        mockNetwork.inject(mock: "getUserAttendedSetlists")
        wrapper.getUserAttendedSetlists(userId: "gloryfades") {
            asyncExpectation.fulfill()
            
            if case .success(let setlistsResponse) = $0 {
                let expectedResponse: Bool = setlistsResponse.setlist?.count == 20 &&
                    setlistsResponse.total == 496 &&
                    setlistsResponse.page == 1 &&
                    setlistsResponse.itemsPerPage == 20
                
                XCTAssertTrue(expectedResponse, "We expected the returned attended setlists response to match the expected attended setlists response, but it did not")
            } else {
                 XCTFail("We expected the call to user/{userId}/attended to succeed, but it did not")
            }
        }
        
        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error, "We expected the call to user/{userId}/attended to succeed, but it timed out instead")
        }
    }
    
    func testGetUserEditedSetlists() {
        let asyncExpectation = expectation(description: "Get data from the user/{userId}/edited endpoint")
        
        mockNetwork.inject(mock: "getUserEditedSetlists")
        wrapper.getUserEditedSetlists(userId: "gloryfades") {
            asyncExpectation.fulfill()
            
            if case .success(let setlistsResponse) = $0 {
                let expectedResponse: Bool = setlistsResponse.setlist?.count == 20 &&
                    setlistsResponse.total == 697 &&
                    setlistsResponse.page == 1 &&
                    setlistsResponse.itemsPerPage == 20
                
                XCTAssertTrue(expectedResponse, "We expected the returned edited setlists response to match the expected edited setlists response, but it did not")
            } else {
                XCTFail("We expected the call to user/{userId}/edited to succeed, but it did not")
            }
        }
        
        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error, "We expected the call to user/{userId}/edited to succeed, but it timed out instead")
        }
    }
    
    func testGetVenueById() {
        let asyncExpectation = expectation(description: "Get data from the venue/{venueId} endpoint")
        
        mockNetwork.inject(mock: "getVenueById")
        wrapper.getVenue(venueId: "gloryfades") {
            asyncExpectation.fulfill()
            
            if case .success(let venue) = $0 {
                let expectedVenue = FMVenue(city: FMCity(id: "5419384",
                                                         name: "Denver",
                                                         stateCode: "CO",
                                                         state: "Colorado",
                                                         coords: FMCoords(lat: 39.7391536, long: -104.9847034),
                                                         country: FMCountry(code: "US", name: "United States")),
                                            url: "https://www.setlist.fm/venue/ogden-theatre-denver-co-usa-6bd63666.html",
                                            id: "6bd63666",
                                            name: "Ogden Theatre")
                
                XCTAssert(venue == expectedVenue, "We expected the returned venue response to match the expected venue response, but it did not")
            } else {
                XCTFail("We expected the call to venue/{venueId} to succeed, but it did not")
            }
        }
        
        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error, "We expected the call to venue/{venueId} to succeed, but it timed out instead")
        }
    }
    
    func testGetVenueSetlists() {
        let asyncExpectation = expectation(description: "Get data from the venue/{venueId}/setlists endpoint")
        
        mockNetwork.inject(mock: "getVenueSetlists")
        wrapper.getVenueSetlists(venueId: "gloryfades") {
            asyncExpectation.fulfill()
            
            if case .success(let setlistsResponse) = $0 {
                let expectedResponse: Bool = setlistsResponse.setlist?.count == 20 &&
                    setlistsResponse.total == 2006 &&
                    setlistsResponse.page == 1 &&
                    setlistsResponse.itemsPerPage == 20
                    
                XCTAssertTrue(expectedResponse, "We expected the returned venue response to match the expected venue response, but it did not")
            } else {
                XCTFail("We expected the call to venue/{venueId}/setlists to succeed, but it did not")
            }
        }
        
        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error, "We expected the call to venue/{venueId}/setlists to succeed, but it timed out instead")
        }
    }
    
    func testFailedSetlistFMRequest() {
        struct FakeRequestModel: SetlistFMRequestModel, Decodable {
            var endpoint: String = "http://fakeaddress:-80"
            var queryParameters: [String : String]?
        }
        
        let asyncExpectation = expectation(description: "Make a bad, fake request")
        let fakeRequestModel = FakeRequestModel()
        let requester = SetlistFMRequest(apiKey: "", language: .english)
        requester.request(fakeRequestModel) { (result: Result<FakeRequestModel, SetlistFMWrapper.FMError>) -> () in
            asyncExpectation.fulfill()
            
            if case .success = result {
                XCTFail("We expected that making a request with an invalid request model would fail, but it did not")
            }
        }
        
        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error, "We expected that making a request with an invalid request model would fail, but it timed out instead")
        }
    }
    
    func testFailedResponseParsing() {
        struct RequestModel: SetlistFMRequestModel, Decodable {
            var endpoint: String = "search/countries"
            var queryParameters: [String : String]?
        }
        
        let asyncExpectation = expectation(description: "Test a real network response using URLSession")
        let requester = SetlistFMRequest(apiKey: "", language: .english)
        requester.request(RequestModel()) { (result: Result<RequestModel, SetlistFMWrapper.FMError>) -> () in
            asyncExpectation.fulfill()
            
            if case .success = result {
                XCTFail("We expected that a request to an endpoint with an invalid parsing description would fail to parse, but it did not")
            }
        }
        
        waitForExpectations(timeout: 2.0) { error in
            XCTAssertNil(error, "We expected the network call to succeed, but it timed out instead")
        }
    }
}

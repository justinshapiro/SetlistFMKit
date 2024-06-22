//
//  SetlistFMWrapper.swift
//  SetlistFMKit
//
//  Created by Justin Shapiro on 8/13/18.
//  Copyright © 2018 Justin Shapiro. All rights reserved.
//

import Foundation

/// The object responsible for providing access to a set of methods that map directly to Setlist.fm API endpoints.
/// Each object returned by the `completion` of the provided methods contains all the data returned from the corresponding endpoint.
/// A built-in network implementation will handle contacting the API, requesting the data, and parsing it.
public final class SetlistFMWrapper {
    
    /// A custom error type that describes a code and a message
    public struct FMError: Error {
        public let code: Int
        public let message: String?
    }
    
    /// The language that the results will return as.
    /// This enum lists all languages supported by the Setlist.fm API.
    public enum SupportedLanguage: String {
        case english    = "en"
        case spanish    = "es"
        case french     = "fr"
        case german     = "de"
        case portuguese = "pt"
        case turkish    = "tr"
        case italian    = "it"
        case polish     = "pl"
    }
    
    /// Strongly-typed version of the sortName parameter, which restricts entry to only the specified types
    public enum SortType: String {
        /// Default sorting type
        case sortName
        
        /// Specifies sorting of the results by relevance
        case relevance
    }
    
    /// Private global request object to be initialized with an API key and a language
    /// and subsequently used for all wrapper-requests
    private let fmRequest: SetlistFMRequest
    
    /// Initializes a SetlistFMWrapper instance with a user-provided API key and desired language.
    /// Generating an API key is required to use the Setlist.fm API. This wrapper will not generate one for you.
    /// - Parameter apiKey: Your API key. Generate an API key for free at [https://www.setlist.fm/settings/api/](https://www.setlist.fm/settings/api/)
    /// - Parameter language: The desired language you wish to obtain results in. `.english` is passed in by default.
    /// - Parameter session: Supply this argument when you want to use a custom networking implementation different than `URLSession.shared`
    public init(apiKey: String, language: SupportedLanguage = .english, session: URLSessionProtocol = URLSession.shared) {
        fmRequest = SetlistFMRequest(apiKey: apiKey, language: language, session: session)
    }
    
    /// Returns an artist for a given Musicbrainz MBID
    /// - Parameter mbid: A Musicbrainz MBID, e.g. 0bfba3d3-6a04-4779-bb0a-df07df5b0558
    /// - Parameter completion: A callback that returns the requested artist as an `FMArtist`
    public func getArtist(mbid: String, _ completion: @escaping (Result<FMArtist, FMError>) -> ()) {
        let requestModel: SetlistFMRequestModel = GetArtistModel(mbid: mbid)
        fmRequest.request(requestModel) { completion($0) }
    }
    
    /// Returns an artist for a given Musicbrainz MBID
    /// - Parameter mbid: A Musicbrainz MBID, e.g. 0bfba3d3-6a04-4779-bb0a-df07df5b0558
    /// - returns: The requested artist as an `FMArtist`
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    public func getArtist(mbid: String) async -> Result<FMArtist, FMError> {
        let requestModel: SetlistFMRequestModel = GetArtistModel(mbid: mbid)
        return await fmRequest.request(requestModel)
    }
    
    /// Get a list of an artist's setlists
    /// - Parameter mbid: The Musicbrainz MBID of the artist
    /// - Parameter pageNumber: The number of the result page. Default value is 1.
    /// - Parameter completion: A callback that returns the requested list of setlists as an `FMSetlistsResult`
    public func getArtistSetlists(mbid: String, pageNumber: Int = 1, _ completion: @escaping (Result<FMSetlistsResult, FMError>) -> ()) {
        let requestModel: SetlistFMRequestModel = GetArtistSetlistsModel(mbid: mbid, p: pageNumber)
        fmRequest.request(requestModel) { completion($0) }
    }
    
    /// Get a list of an artist's setlists
    /// - Parameter mbid: The Musicbrainz MBID of the artist
    /// - Parameter pageNumber: The number of the result page. Default value is 1.
    /// - returns: The requested list of setlists as an `FMSetlistsResult`
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    public func getArtistSetlists(mbid: String, pageNumber: Int = 1) async -> Result<FMSetlistsResult, FMError> {
        let requestModel: SetlistFMRequestModel = GetArtistSetlistsModel(mbid: mbid, p: pageNumber)
        return await fmRequest.request(requestModel)
    }
    
    /// Get a city by its unique geoId
    /// - Parameter geoId: The city's geoId
    /// - Parameter completion: A callback that returns the requested city as an `FMCity`
    public func getCity(geoId: String, _ completion: @escaping (Result<FMCity, FMError>) -> ()) {
        let requestModel: SetlistFMRequestModel = GetCityModel(geoId: geoId)
        fmRequest.request(requestModel) { completion($0) }
    }
    
    /// Get a city by its unique geoId
    /// - Parameter geoId: The city's geoId
    /// - returns: The requested city as an `FMCity`
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    public func getCity(geoId: String) async -> Result<FMCity, FMError> {
        let requestModel: SetlistFMRequestModel = GetCityModel(geoId: geoId)
        return await fmRequest.request(requestModel)
    }
    
    /// Search for artists.
    /// **You must specify at least one parameter in the set** { `artistMBID`, `artistName`, `artistTMID` }
    /// **for the call to succeed**
    /// - Parameter artistMbid: The artist's Musicbrainz Identifier (mbid)
    /// - Parameter artistName: The artist's name
    /// - Parameter artistTmid: The artist's Ticketmaster Identifier (tmid)
    /// - Parameter pageNumber: The number of the result page you'd like to have
    /// - Parameter sortedBy: The sort of the result, either sortName (default) or relevance
    /// - Parameter completion: A callback that returns the requested list of artists as an `FMArtistsResult`
    public func searchArtists(artistMbid: String? = nil,
                              artistName: String? = nil,
                              artistTmid: Int? = nil,
                              pageNumber: Int = 1,
                              sortedBy sortType: SortType = .sortName,
                              _ completion: @escaping (Result<FMArtistsResult, FMError>) -> ()) {
        let requestModel: SetlistFMRequestModel = SearchArtistsModel(
            artistMbid: artistMbid ?? "",
            artistName: artistName ?? "",
            artistTmid: artistTmid.flatMap { "\($0)" } ?? "",
            p: pageNumber,
            sort: sortType.rawValue
        )
        
        fmRequest.request(requestModel) { completion($0) }
    }
    
    /// Search for artists.
    /// **You must specify at least one parameter in the set** { `artistMBID`, `artistName`, `artistTMID` }
    /// **for the call to succeed**
    /// - Parameter artistMbid: The artist's Musicbrainz Identifier (mbid)
    /// - Parameter artistName: The artist's name
    /// - Parameter artistTmid: The artist's Ticketmaster Identifier (tmid)
    /// - Parameter pageNumber: The number of the result page you'd like to have
    /// - Parameter sortedBy: The sort of the result, either sortName (default) or relevance
    /// - returns: The requested list of artists as an `FMArtistsResult`
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    public func searchArtists(artistMbid: String? = nil,
                              artistName: String? = nil,
                              artistTmid: Int? = nil,
                              pageNumber: Int = 1,
                              sortedBy sortType: SortType = .sortName) async -> Result<FMArtistsResult, FMError> {
        let requestModel: SetlistFMRequestModel = SearchArtistsModel(
            artistMbid: artistMbid ?? "",
            artistName: artistName ?? "",
            artistTmid: artistTmid.flatMap { "\($0)" } ?? "",
            p: pageNumber,
            sort: sortType.rawValue
        )
        
        return await fmRequest.request(requestModel)
    }
    
    /// Search for a city. **You must specify one parameter other than** `pageNumber` **for the call to succeed**
    /// - Parameter country: The city's country. Specify the country code rather than the full name of the country, otherwise a 404 will occur.
    /// - Parameter name: Name of the city
    /// - Parameter pageNumber: The number of the result page you'd like to have
    /// - Parameter state: State the city lies in. Unlike `country`, you can specify the full name of the state here
    /// - Parameter stateCode: State code the city lies in
    /// - Parameter completion: A callback that returns the requested list of cities as an `FMCitiesResult`
    public func searchCities(country: String? = nil,
                             name: String? = nil,
                             pageNumber: Int = 1,
                             state: String? = nil,
                             stateCode: String? = nil,
                             _ completion: @escaping (Result<FMCitiesResult, FMError>) -> ()) {
        let requestModel: SetlistFMRequestModel = SearchCitiesModel(
            country: country ?? "",
            name: name ?? "",
            p: pageNumber,
            state: state ?? "",
            stateCode: stateCode ?? ""
        )
        
        fmRequest.request(requestModel) { completion($0) }
    }
    
    /// Search for a city. **You must specify one parameter other than** `pageNumber` **for the call to succeed**
    /// - Parameter country: The city's country. Specify the country code rather than the full name of the country, otherwise a 404 will occur.
    /// - Parameter name: Name of the city
    /// - Parameter pageNumber: The number of the result page you'd like to have
    /// - Parameter state: State the city lies in. Unlike `country`, you can specify the full name of the state here
    /// - Parameter stateCode: State code the city lies in
    /// - returns: The requested list of cities as an `FMCitiesResult`
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    public func searchCities(country: String? = nil,
                             name: String? = nil,
                             pageNumber: Int = 1,
                             state: String? = nil,
                             stateCode: String? = nil) async -> Result<FMCitiesResult, FMError> {
        let requestModel: SetlistFMRequestModel = SearchCitiesModel(
            country: country ?? "",
            name: name ?? "",
            p: pageNumber,
            state: state ?? "",
            stateCode: stateCode ?? ""
        )
        
        return await fmRequest.request(requestModel)
    }
    
    /// Get a complete list of all supported countries
    /// - Parameter completion: A callback that returns the requested list of countries as an `FMCountriesResult`
    public func searchCountries(_ completion: @escaping (Result<FMCountriesResult, FMError>) -> ()) {
        let requestModel: SetlistFMRequestModel = SearchCountriesModel()
        fmRequest.request(requestModel) { completion($0) }
    }
    
    /// Get a complete list of all supported countries
    /// - returns: The requested list of countries as an `FMCountriesResult`
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    public func searchCountries() async -> Result<FMCountriesResult, FMError> {
        let requestModel: SetlistFMRequestModel = SearchCountriesModel()
        return await fmRequest.request(requestModel)
    }
    
    /// Search for setlists. **You must specify one parameter other than** `pageNumber` **for the call to succeed**
    /// - Parameter artistMbid: The artist's Musicbrainz Identifier (mbid)
    /// - Parameter artistName: The artist's name
    /// - Parameter artistTmid: The artist's Ticketmaster Identifier (tmid)
    /// - Parameter cityId: The city's geoId
    /// - Parameter cityName: The name of the city
    /// - Parameter countryCode: The country code
    /// - Parameter date: The date of the event (format dd-MM-yyyy)
    /// - Parameter lastFM: The event's Last.fm Event ID (deprecated)
    /// - Parameter lastUpdated: The date and time (UTC) when this setlist was last updated (format yyyyMMddHHmmss) -
    /// either edited or reverted. Search will return setlists that were updated on or after this date
    /// - Parameter pageNumber: The number of the result page
    /// - Parameter state: The state
    /// - Parameter stateCode: The state code
    /// - Parameter tourName: The name of the tour
    /// - Parameter venueId: The venue id
    /// - Parameter venueName: The name of the venue
    /// - Parameter year: The year of the event
    /// - Parameter completion: A callback that returns the requested list of setlists as an `FMSetlistsResult`
    public func searchSetlists(artistMbid: String? = nil,
                               artistName: String? = nil,
                               artistTmid: Int? = nil,
                               cityId: String? = nil,
                               cityName: String? = nil,
                               countryCode: String? = nil,
                               date: String? = nil,
                               lastFM: String? = nil,
                               lastUpdated: String? = nil,
                               pageNumber: Int = 1,
                               state: String? = nil,
                               stateCode: String? = nil,
                               tourName: String? = nil,
                               venueId: String? = nil,
                               venueName: String? = nil,
                               year: String? = nil,
                               _ completion: @escaping (Result<FMSetlistsResult, FMError>) -> ()) {
        let requestModel: SetlistFMRequestModel = SearchSetlistsModel(
            artistMbid: artistMbid ?? "",
            artistName: artistName ?? "",
            artistTmid: artistTmid.flatMap { "\($0)" } ?? "",
            cityId: cityId ?? "",
            cityName: cityName ?? "",
            countryCode: countryCode ?? "",
            date: date ?? "",
            lastFM: lastFM ?? "",
            lastUpdated: lastUpdated ?? "",
            p: pageNumber,
            state: state ?? "",
            stateCode: stateCode ?? "",
            tourName: tourName ?? "",
            venueId: venueId ?? "",
            venueName: venueName ?? "",
            year: year ?? ""
        )
        
        fmRequest.request(requestModel) { completion($0) }
    }
    
    /// Search for setlists. **You must specify one parameter other than** `pageNumber` **for the call to succeed**
    /// - Parameter artistMbid: The artist's Musicbrainz Identifier (mbid)
    /// - Parameter artistName: The artist's name
    /// - Parameter artistTmid: The artist's Ticketmaster Identifier (tmid)
    /// - Parameter cityId: The city's geoId
    /// - Parameter cityName: The name of the city
    /// - Parameter countryCode: The country code
    /// - Parameter date: The date of the event (format dd-MM-yyyy)
    /// - Parameter lastFM: The event's Last.fm Event ID (deprecated)
    /// - Parameter lastUpdated: The date and time (UTC) when this setlist was last updated (format yyyyMMddHHmmss) -
    /// either edited or reverted. Search will return setlists that were updated on or after this date
    /// - Parameter pageNumber: The number of the result page
    /// - Parameter state: The state
    /// - Parameter stateCode: The state code
    /// - Parameter tourName: The name of the tour
    /// - Parameter venueId: The venue id
    /// - Parameter venueName: The name of the venue
    /// - Parameter year: The year of the event
    /// - returns: The requested list of setlists as an `FMSetlistsResult`
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    public func searchSetlists(artistMbid: String? = nil,
                               artistName: String? = nil,
                               artistTmid: Int? = nil,
                               cityId: String? = nil,
                               cityName: String? = nil,
                               countryCode: String? = nil,
                               date: String? = nil,
                               lastFM: String? = nil,
                               lastUpdated: String? = nil,
                               pageNumber: Int = 1,
                               state: String? = nil,
                               stateCode: String? = nil,
                               tourName: String? = nil,
                               venueId: String? = nil,
                               venueName: String? = nil,
                               year: String? = nil) async -> Result<FMSetlistsResult, FMError> {
        let requestModel: SetlistFMRequestModel = SearchSetlistsModel(
            artistMbid: artistMbid ?? "",
            artistName: artistName ?? "",
            artistTmid: artistTmid.flatMap { "\($0)" } ?? "",
            cityId: cityId ?? "",
            cityName: cityName ?? "",
            countryCode: countryCode ?? "",
            date: date ?? "",
            lastFM: lastFM ?? "",
            lastUpdated: lastUpdated ?? "",
            p: pageNumber,
            state: state ?? "",
            stateCode: stateCode ?? "",
            tourName: tourName ?? "",
            venueId: venueId ?? "",
            venueName: venueName ?? "",
            year: year ?? ""
        )
        
        return await fmRequest.request(requestModel)
    }
    
    /// Search for venues.
    /// - Parameter cityId: The city's geoId
    /// - Parameter cityName: Name of the city where the venue is located
    /// - Parameter country: The city's country
    /// - Parameter name: Name of the venue
    /// - Parameter pageNumber: The number of the result page you'd like to have
    /// - Parameter state: The city's state
    /// - Parameter stateCode: The city's state code
    /// - Parameter completion: A callback that returns the requested list of venues as an `FMVenuesResult`
    public func searchVenues(cityId: String? = nil,
                             cityName: String? = nil,
                             country: String? = nil,
                             name: String? = nil,
                             pageNumber: Int = 1,
                             state: String? = nil,
                             stateCode: String? = nil,
                             _ completion: @escaping (Result<FMVenuesResult, FMError>) -> ()) {
        let requestModel: SetlistFMRequestModel = SearchVenuesModel(
            cityId: cityId ?? "",
            cityName: cityName ?? "",
            country: country ?? "",
            name: name ?? "",
            p: pageNumber,
            state: state ?? "",
            stateCode: stateCode ?? ""
        )
        
        fmRequest.request(requestModel) { completion($0) }
    }
    
    /// Search for venues.
    /// - Parameter cityId: The city's geoId
    /// - Parameter cityName: Name of the city where the venue is located
    /// - Parameter country: The city's country
    /// - Parameter name: Name of the venue
    /// - Parameter pageNumber: The number of the result page you'd like to have
    /// - Parameter state: The city's state
    /// - Parameter stateCode: The city's state code
    /// - returns: The requested list of venues as an `FMVenuesResult`
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    public func searchVenues(cityId: String? = nil,
                             cityName: String? = nil,
                             country: String? = nil,
                             name: String? = nil,
                             pageNumber: Int = 1,
                             state: String? = nil,
                             stateCode: String? = nil) async -> Result<FMVenuesResult, FMError> {
        let requestModel: SetlistFMRequestModel = SearchVenuesModel(
            cityId: cityId ?? "",
            cityName: cityName ?? "",
            country: country ?? "",
            name: name ?? "",
            p: pageNumber,
            state: state ?? "",
            stateCode: stateCode ?? ""
        )
        
        return await fmRequest.request(requestModel)
    }
    
    /// Returns the current version of a setlist.
    /// E.g. if you pass the id of a setlist that got edited since you last accessed it,
    /// you'll get the current version.
    /// - Parameter setlistId: The setlist id
    /// - Parameter completion: A callback that returns the requested setlist as an `FMSetlist`
    public func getSetlist(setlistId: String, _ completion: @escaping (Result<FMSetlist, FMError>) -> ()) {
        let requestModel: SetlistFMRequestModel = GetSetlistModel(setlistId: setlistId)
        fmRequest.request(requestModel) { completion($0) }
    }
    
    /// Returns the current version of a setlist.
    /// E.g. if you pass the id of a setlist that got edited since you last accessed it,
    /// you'll get the current version.
    /// - Parameter setlistId: The setlist id
    /// - returns: The requested setlist as an `FMSetlist`
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    public func getSetlist(setlistId: String) async -> Result<FMSetlist, FMError> {
        let requestModel: SetlistFMRequestModel = GetSetlistModel(setlistId: setlistId)
        return await fmRequest.request(requestModel)
    }
    
    /// Returns a setlist for the given versionId.
    /// The setlist returned isn't necessarily the most recent version.
    /// E.g. if you pass the versionId of a setlist that got edited since you last accessed it,
    /// you'll get the same version as last time.
    /// - Parameter versionId: The version id
    /// - Parameter completion: A callback that returns the requested setlist version as an `FMSetlist`
    public func getSetlistVersion(versionId: String, _ completion: @escaping (Result<FMSetlist, FMError>) -> ()) {
        let requestModel: SetlistFMRequestModel = GetSetlistVersionModel(versionId: versionId)
        fmRequest.request(requestModel) { completion($0) }
    }
    
    /// Returns a setlist for the given versionId.
    /// The setlist returned isn't necessarily the most recent version.
    /// E.g. if you pass the versionId of a setlist that got edited since you last accessed it,
    /// you'll get the same version as last time.
    /// - Parameter versionId: The version id
    /// - returns: The requested setlist version as an `FMSetlist`
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    public func getSetlistVersion(versionId: String) async -> Result<FMSetlist, FMError> {
        let requestModel: SetlistFMRequestModel = GetSetlistVersionModel(versionId: versionId)
        return await fmRequest.request(requestModel)
    }
    
    /// Get a user by userId
    /// - Parameter userId: The user's userId
    /// - Parameter completion: A callback that returns the requested user as an `FMUser`
    public func getUser(userId: String, _ completion: @escaping (Result<FMUser, FMError>) -> ()) {
        let requestModel: SetlistFMRequestModel = GetUserModel(userId: userId)
        fmRequest.request(requestModel) { completion($0) }
    }
    
    /// Get a user by userId
    /// - Parameter userId: The user's userId
    /// - returns: The requested user as an `FMUser`
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    public func getUser(userId: String) async -> Result<FMUser, FMError> {
        let requestModel: SetlistFMRequestModel = GetUserModel(userId: userId)
        return await fmRequest.request(requestModel)
    }
    
    /// Get a list of setlists of concerts attended by a user
    /// - Parameter userId: The user's userId
    /// - Parameter pageNumber: The number of the result page
    /// - Parameter completion: A callback that returns the requested user's attended setlists as an `FMSetlistsResult`
    public func getUserAttendedSetlists(userId: String, pageNumber: Int = 1, _ completion: @escaping (Result<FMSetlistsResult, FMError>) -> ()) {
        let requestModel: SetlistFMRequestModel = GetUserAttendedModel(userId: userId, p: pageNumber)
        fmRequest.request(requestModel) { completion($0) }
    }
    
    /// Get a list of setlists of concerts attended by a user
    /// - Parameter userId: The user's userId
    /// - Parameter pageNumber: The number of the result page
    /// - returns: The requested user's attended setlists as an `FMSetlistsResult`
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    public func getUserAttendedSetlists(userId: String, pageNumber: Int = 1) async -> Result<FMSetlistsResult, FMError> {
        let requestModel: SetlistFMRequestModel = GetUserAttendedModel(userId: userId, p: pageNumber)
        return await fmRequest.request(requestModel)
    }
    
    /// Get a list of setlists of concerts edited by a user. The list contains the current version, not the version edited
    /// - Parameter userId: The user's userId
    /// - Parameter pageNumber: The number of the result page
    /// - Parameter completion: A callback that returns the requested user's edited setlists as an `FMSetlistsResult`
    public func getUserEditedSetlists(userId: String, pageNumber: Int = 1, _ completion: @escaping (Result<FMSetlistsResult, FMError>) -> ()) {
        let requestModel: SetlistFMRequestModel = GetUserEditedModel(userId: userId, p: pageNumber)
        fmRequest.request(requestModel) { completion($0) }
    }
    
    /// Get a list of setlists of concerts edited by a user. The list contains the current version, not the version edited
    /// - Parameter userId: The user's userId
    /// - Parameter pageNumber: The number of the result page
    /// - returns: The requested user's edited setlists as an `FMSetlistsResult`
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    public func getUserEditedSetlists(userId: String, pageNumber: Int = 1) async -> Result<FMSetlistsResult, FMError> {
        let requestModel: SetlistFMRequestModel = GetUserEditedModel(userId: userId, p: pageNumber)
        return await fmRequest.request(requestModel)
    }
    
    /// Get a venue by its unique id
    /// - Parameter venueId: The venue's id
    /// - Parameter completion: A callback that returns the requested venue as an `FMVenue`
    public func getVenue(venueId: String, _ completion: @escaping (Result<FMVenue, FMError>) -> ()) {
        let requestModel: SetlistFMRequestModel = GetVenueModel(venueId: venueId)
        fmRequest.request(requestModel) { completion($0) }
    }
    
    /// Get a venue by its unique id
    /// - Parameter venueId: The venue's id
    /// - returns : The requested venue as an `FMVenue`
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    public func getVenue(venueId: String) async -> Result<FMVenue, FMError> {
        let requestModel: SetlistFMRequestModel = GetVenueModel(venueId: venueId)
        return await fmRequest.request(requestModel)
    }
    
    /// Get a venue by its unique id
    /// - Parameter venueId: The venue's id
    /// - Parameter pageNumber: The number of the result page
    /// - Parameter completion: A callback that returns the requested venue's setlists as an `FMSetlistsResult`
    public func getVenueSetlists(venueId: String, pageNumber: Int = 1, _ completion: @escaping (Result<FMSetlistsResult, FMError>) -> ()) {
        let requestModel: SetlistFMRequestModel = GetVenueSetlistsModel(venueId: venueId, p: pageNumber)
        fmRequest.request(requestModel) { completion($0) }
    }
    
    /// Get a venue by its unique id
    /// - Parameter venueId: The venue's id
    /// - Parameter pageNumber: The number of the result page
    /// - returns: The requested venue's setlists as an `FMSetlistsResult`
    @available(macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0, *)
    public func getVenueSetlists(venueId: String, pageNumber: Int = 1) async -> Result<FMSetlistsResult, FMError> {
        let requestModel: SetlistFMRequestModel = GetVenueSetlistsModel(venueId: venueId, p: pageNumber)
        return await fmRequest.request(requestModel)
    }
}

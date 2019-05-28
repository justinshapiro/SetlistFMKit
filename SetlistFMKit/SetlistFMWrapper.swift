//
//  SetlistFMWrapper.swift
//  SetlistFMKit
//
//  Created by Justin Shapiro on 8/13/18.
//  Copyright © 2018 Justin Shapiro. All rights reserved.
//

/// The object responsible for providing access to a set of methods that map directly to Setlist.fm API endpoints.
/// Each object returned by the `completion` of the provided methods contains all the data returned from the corresponding endpoint.
/// A built-in network implementation will handle contacting the API, requesting the data, and parsing it.
public final class SetlistFMWrapper {
    /// A custom error type that describes a code and a message
    struct FMError: Error {
        let code: Int
        let message: String?
    }
    
    /// The language that the results will return as.
    /// This enum lists all languages supported by the Setlist.fm API.
    enum SupportedLanguage: String {
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
    enum SortType: String {
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
    init(apiKey: String, language: SupportedLanguage = .english, session: URLSessionProtocol = URLSession.shared) {
        fmRequest = SetlistFMRequest(apiKey: apiKey, language: language, session: session)
    }
    
    /// Returns an artist for a given Musicbrainz MBID
    /// - Parameter mbid: A Musicbrainz MBID, e.g. 0bfba3d3-6a04-4779-bb0a-df07df5b0558
    /// - Parameter completion: A callback that returns the requested artist as an `FMArtist`
    func getArtist(mbid: String, _ completion: @escaping (Result<FMArtist, FMError>) -> ()) {
        let requestModel: SetlistFMRequestModel = GetArtistModel(mbid: mbid)
        fmRequest.request(requestModel) { completion($0) }
    }
    
    /// Get a list of an artist's setlists
    /// - Parameter mbid: The Musicbrainz MBID of the artist
    /// - Parameter pageNumber: The number of the result page. Default value is 1.
    /// - Parameter completion: A callback that returns the requested list of setlists as an `FMSetlistsResult`
    func getArtistSetlists(mbid: String, pageNumber: Int = 1, _ completion: @escaping (Result<FMSetlistsResult, FMError>) -> ()) {
        let requestModel: SetlistFMRequestModel = GetArtistSetlistsModel(mbid: mbid, p: pageNumber)
        fmRequest.request(requestModel) { completion($0) }
    }
    
    /// Get a city by its unique geoId
    /// - Parameter geoId: The city's geoId
    /// - Parameter completion: A callback that returns the requested city as an `FMCity`
    func getCity(geoId: String, _ completion: @escaping (Result<FMCity, FMError>) -> ()) {
        let requestModel: SetlistFMRequestModel = GetCityModel(geoId: geoId)
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
    /// - Parameter completion: A callback that returns the requested list of artists as an `FMArtistsResult`
    func searchArtists(artistMbid: String? = nil,
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
    
    /// Search for a city. **You must specify one parameter other than** `pageNumber` **for the call to succeed**
    /// - Parameter country: The city's country. Specify the country code rather than the full name of the country, otherwise a 404 will occur.
    /// - Parameter name: Name of the city
    /// - Parameter pageNumber: The number of the result page you'd like to have
    /// - Parameter state: State the city lies in. Unlike `country`, you can specify the full name of the state here
    /// - Parameter stateCode: State code the city lies in
    /// - Parameter complete: A callback that returns the requested list of cities as an `FMCitiesResult`
    func searchCities(country: String? = nil,
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
    
    /// Get a complete list of all supported countries
    /// - Parameter completion: A callback that returns the requested list of countries as an `FMCountriesResult`
    func searchCountries(_ completion: @escaping (Result<FMCountriesResult, FMError>) -> ()) {
        let requestModel: SetlistFMRequestModel = SearchCountriesModel()
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
    /// - Parameter completion: A callback that returns the requested list of setlists as an `FMSetlistsResult`
    func searchSetlists(artistMbid: String? = nil,
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
    
    /// Search for venues.
    /// - Parameter cityId: The city's geoId
    /// - Parameter cityName: Name of the city where the venue is located
    /// - Parameter country: The city's country
    /// - Parameter name: Name of the venue
    /// - Parameter pageNumber: The number of the result page you'd like to have
    /// - Parameter state: The city's state
    /// - Parameter stateCode: The city's state code
    /// - Parameter completion: A callback that returns the requested list of venues as an `FMVenuesResult`
    func searchVenues(cityId: String? = nil,
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
    
    /// Returns the current version of a setlist.
    /// E.g. if you pass the id of a setlist that got edited since you last accessed it,
    /// you'll get the current version.
    /// - Parameter setlistId: The setlist id
    /// - Parameter completion: A callback that returns the requested setlist as an `FMSetlist`
    func getSetlist(setlistId: String, _ completion: @escaping (Result<FMSetlist, FMError>) -> ()) {
        let requestModel: SetlistFMRequestModel = GetSetlistModel(setlistId: setlistId)
        fmRequest.request(requestModel) { completion($0) }
    }
    
    /// Returns a setlist for the given versionId.
    /// The setlist returned isn't necessarily the most recent version.
    /// E.g. if you pass the versionId of a setlist that got edited since you last accessed it,
    /// you'll get the same version as last time.
    /// - Parameter versionId: The version id
    /// - Parameter completion: A callback that returns the requested setlist version as an `FMSetlist`
    func getSetlistVersion(versionId: String, _ completion: @escaping (Result<FMSetlist, FMError>) -> ()) {
        let requestModel: SetlistFMRequestModel = GetSetlistVersionModel(versionId: versionId)
        fmRequest.request(requestModel) { completion($0) }
    }
    
    /// Get a user by userId
    /// - Parameter userId: The user's userId
    /// - Parameter completion: A callback that returns the requested user as an `FMUser`
    func getUser(userId: String, _ completion: @escaping (Result<FMUser, FMError>) -> ()) {
        let requestModel: SetlistFMRequestModel = GetUserModel(userId: userId)
        fmRequest.request(requestModel) { completion($0) }
    }
    
    /// Get a list of setlists of concerts attended by a user
    /// - Parameter userId: The user's userId
    /// - Parameter pageNumber: The number of the result page
    /// - Parameter completion: A callback that returns the requested user's attended setlists as an `FMSetlistsResult`
    func getUserAttendedSetlists(userId: String, pageNumber: Int = 1, _ completion: @escaping (Result<FMSetlistsResult, FMError>) -> ()) {
        let requestModel: SetlistFMRequestModel = GetUserAttendedModel(userId: userId, p: pageNumber)
        fmRequest.request(requestModel) { completion($0) }
    }
    
    /// Get a list of setlists of concerts edited by a user. The list contains the current version, not the version edited
    /// - Parameter userId: The user's userId
    /// - Parameter pageNumber: The number of the result page
    /// - Parameter completion: A callback that returns the requested user's edited setlists as an `FMSetlistsResult`
    func getUserEditedSetlists(userId: String, pageNumber: Int = 1, _ completion: @escaping (Result<FMSetlistsResult, FMError>) -> ()) {
        let requestModel: SetlistFMRequestModel = GetUserEditedModel(userId: userId, p: pageNumber)
        fmRequest.request(requestModel) { completion($0) }
    }
    
    /// Get a venue by its unique id
    /// - Parameter venueId: The venue's id
    /// - Parameter completion: A callback that returns the requested venue as an `FMVenue`
    func getVenue(venueId: String, _ completion: @escaping (Result<FMVenue, FMError>) -> ()) {
        let requestModel: SetlistFMRequestModel = GetVenueModel(venueId: venueId)
        fmRequest.request(requestModel) { completion($0) }
    }
    
    /// Get a venue by its unique id
    /// - Parameter venueId: The venue's id
    /// - Parameter pageNumber: The number of the result page
    /// - Parameter completion: A callback that returns the requested venue's setlists as an `FMSetlistsResult`
    func getVenueSetlists(venueId: String, pageNumber: Int = 1, _ completion: @escaping (Result<FMSetlistsResult, FMError>) -> ()) {
        let requestModel: SetlistFMRequestModel = GetVenueSetlistsModel(venueId: venueId, p: pageNumber)
        fmRequest.request(requestModel) { completion($0) }
    }
}

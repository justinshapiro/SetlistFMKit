//
//  SetlistFmRequestModels.swift
//  SetlistFmKit
//
//  Created by Justin Shapiro on 8/13/18.
//  Copyright © 2018 Justin Shapiro. All rights reserved.
//

/// The request model for requests to the /artist/{mbid} endpoint
struct GetArtistModel: SetlistFmRequestModel {
    /// A Musicbrainz MBID, e.g. 0bfba3d3-6a04-4779-bb0a-df07df5b0558
    let mbid: String
    
    var endpoint: String { return "artist/\(mbid)" }
    var queryParameters: [String : String]? { return nil }
}

/// The request model for requests to the /artist/{mbid}/setlists endpoint
struct GetArtistSetlistsModel: SetlistFmRequestModel {
    /// The Musicbrainz MBID of the artist
    let mbid: String
    
    /// The number of the result page
    let p: Int
    
    var endpoint: String { return "artist/\(mbid)/setlists" }
    var queryParameters: [String : String]? { return ["p": "\(p)"] }
}

/// The request model for requests to the /city/{geoId} endpoint
struct GetCityModel: SetlistFmRequestModel {
    /// The city's geoId
    let geoId: String
    
    var endpoint: String { return "city/\(geoId)" }
    var queryParameters: [String : String]? { return nil}
}

/// The request model for requests to the /search/artists endpoint
struct SearchArtistsModel: SetlistFmRequestModel {
    /// The artist's Musicbrainz Identifier (mbid)
    let artistMbid: String
    
    /// The artist's name
    let artistName: String
    
    /// The artist's Ticketmaster Identifier (tmid)
    let artistTmid: String
    
    /// The number of the result page you'd like to have
    let p: Int
    
    /// The sort of the result, either sortName (default) or relevance
    let sort: String
    
    var endpoint: String { return "search/artists" }
    var queryParameters: [String : String]? {
        return [
            "artistMbid": artistMbid,
            "artistTmid": artistTmid,
            "p": "\(p)",
            "sort": sort
        ]
    }
}

/// The request model for requests to the /search/cities endpoint
struct SearchCitiesModel: SetlistFmRequestModel {
    /// The city's country
    let country: String
    
    /// Name of the city
    let name: String
    
    /// the number of the result page you'd like to have
    let p: Int
    
    /// State the city lies in
    let state: String
    
    /// State code the city lies in
    let stateCode: String
    
    var endpoint: String { return "search/cities" }
    var queryParameters: [String : String]? {
        return [
            "country": country,
            "name": name,
            "p": "\(p)",
            "state": state,
            "stateCode": stateCode
        ]
    }
}

/// The request model for requests to the /search/countries endpoint
struct SearchCountriesModel: SetlistFmRequestModel {
    var endpoint: String { return "search/countries"}
    var queryParameters: [String : String]? { return nil }
}

/// The request model for requests to the /search/setlists endpoint
struct SearchSetlistsModel: SetlistFmRequestModel {
    /// The artist's Musicbrainz Identifier (mbid)
    let artistMbid: String
    
    /// The artist's name
    let artistName: String
    
    /// The artist's Ticketmaster Identifier (tmid)
    let artistTmid: String
    
    /// The city's geoId
    let cityId: String
    
    /// The name of the city
    let cityName: String
    
    /// The country code
    let countryCode: String
    
    /// The date of the event (format dd-MM-yyyy)
    let date: String
    
    /// The event's Last.fm Event ID (deprecated)
    let lastFm: String
    
    /// The date and time (UTC) when this setlist was last updated (format yyyyMMddHHmmss) -
    /// either edited or reverted. Search will return setlists that were updated on or after this date.
    let lastUpdated: String
    
    /// The number of the result page
    let p: Int
    
    /// The state
    let state: String
    
    /// The state code
    let stateCode: String
    
    /// The name of the tour
    let tourName: String
    
    /// The venue id
    let venueId: String
    
    /// The name of the venue
    let venueName: String
    
    /// The year of the event
    let year: String
    
    var endpoint: String { return "search/setlists"}
    var queryParameters: [String : String]? {
        return [
            "artistMbid": artistMbid,
            "artistName": artistName,
            "artistTmid": artistTmid,
            "cityId": cityId,
            "cityName": cityName,
            "countryCode": countryCode,
            "date": date,
            "lastFm": lastFm,
            "lastUpdated": lastUpdated,
            "p": "\(p)",
            "state": state,
            "stateCode": stateCode,
            "tourName": tourName,
            "venueId": venueId,
            "venueName": venueName,
            "year": year
        ]
    }
}

/// The request model for requests to the /search/venues endpoint
struct SearchVenuesModel: SetlistFmRequestModel {
    /// The city's geoId
    let cityId: String
    
    /// Name of the city where the venue is located
    let cityName: String
    
    /// The city's country
    let country: String
    
    /// Name of the venue
    let name: String
    
    /// The number of the result page you'd like to have
    let p: Int
    
    /// The city's state
    let state: String
    
    /// The city's state code
    let stateCode: String
    
    var endpoint: String { return "search/venues"}
    var queryParameters: [String : String]? {
        return [
            "cityId": cityId,
            "cityName": cityName,
            "country": country,
            "name": name,
            "p": "\(p)",
            "state": state,
            "stateCode": stateCode
        ]
    }
}

/// The request model for requests to the /setlist/{setlistId} endpoint
struct GetSetlistModel: SetlistFmRequestModel {
    /// The setlist id
    let setlistId: String
    
    var endpoint: String { return "setlist/\(setlistId)" }
    var queryParameters: [String : String]? { return nil }
}

/// The request model for requests to the /setlist/version/{versionId} endpoint
struct GetSetlistVersionModel: SetlistFmRequestModel {
    /// The version id
    let versionId: String
    
    var endpoint: String { return "setlist/version/\(versionId)" }
    var queryParameters: [String : String]? { return nil }
}

/// The request model for requests to the /user/{userId} endpoint
struct GetUserModel: SetlistFmRequestModel {
    /// The user's userId
    let userId: String
    
    var endpoint: String { return "user/\(userId)" }
    var queryParameters: [String : String]? { return nil }
}

/// The request model for requests to the /user/{userId}/attended endpoint
struct GetUserAttendedModel: SetlistFmRequestModel {
    /// The user's userId
    let userId: String
    
    /// The number of the result page
    let p: Int
    
    var endpoint: String { return "user/\(userId)/attended" }
    var queryParameters: [String : String]? { return ["p": "\(p)"] }
}

/// The request model for requests to the /user/{userId}/edited endpoint
struct GetUserEditedModel: SetlistFmRequestModel {
    /// The user's userId
    let userId: String
    
    /// The number of the result page
    let p: Int
    
    var endpoint: String { return "user/\(userId)/edited" }
    var queryParameters: [String : String]? { return ["p": "\(p)"] }
}

/// The request model for requests to the /venue/{venueId} endpoint
struct GetVenueModel: SetlistFmRequestModel {
    /// The venue's id
    let venueId: String
    
    var endpoint: String { return "venue/\(venueId)" }
    var queryParameters: [String : String]? { return nil }
}

/// The request model for requests to the /user/{userId}/edited endpoint
struct GetVenueSetlistsModel: SetlistFmRequestModel {
    /// The venue's id
    let venueId: String
    
    /// The number of the result page
    let p: Int
    
    var endpoint: String { return "user/\(venueId)/setlists" }
    var queryParameters: [String : String]? { return ["p": "\(p)"] }
}

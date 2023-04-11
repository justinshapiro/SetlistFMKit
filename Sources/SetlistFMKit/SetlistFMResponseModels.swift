//
//  SetlistFMResponseModels.swift
//  SetlistFMKit
//
//  Created by Justin Shapiro on 8/11/18.
//  Copyright © 2018 Justin Shapiro. All rights reserved.
//

/// The response model for a Setlist.fm API request containing multiple setlists
public struct FMSetlistsResult: Decodable, Equatable {
    /// Result list of setlists
    public let setlist: [FMSetlist]?
    
    /// The total amount of items matching the query
    public let total: Int?
    
    /// The current page. Starts at 1
    public let page: Int?
    
    /// The amount of items you get per page
    public let itemsPerPage: Int?
}

/// The model for a Setlist object from the Setlist.fm API
public struct FMSetlist: Decodable, Equatable {
    /// The setlist's artist
    public let artist: FMArtist?
    
    /// The setlist's venue
    public let venue: FMVenue?
    
    /// The setlist's tour
    public let tour: FMTour?
    
    /// All sets of this setlist
    public let sets: FMSets?
    
    /// Additional information on the concert -
    /// see the [setlist.fm guidelines](https://www.setlist.fm/guidelines) for a complete list of allowed content
    public let info: String?
    
    /// The attribution url to which you have to link to wherever you use data from this setlist in your application
    public let url: String?
    
    /// Unique identifier
    public let id: String?
    
    /// Unique identifier of the version
    public let versionId: String?
    
    /// The id this event has on [last.fm](http://last.fm/) (deprecated)
    public let lastFMEventId: Int?
    
    /// Date of the concert in the format "dd-MM-yyyy"
    public let eventDate: String?
    
    /// Date, time and time zone of the last update to this setlist in the format "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
    public let lastUpdated: String?
}

/// The model for the upper-level `sets` JSON object, which just holds an array of `FMSet`
public struct FMSets: Decodable, Equatable {
    /// The list of sets
    public let set: [FMSet]?
}

/// The response model for a Setlist.fm API request containing multiple artists
public struct FMArtistsResult: Decodable, Equatable {
    // Result list of artists
    public let artist: [FMArtist]?
    
    /// The total amount of items matching the query
    public let total: Int?
    
    /// The current page. Starts at 1.
    public let page: Int?
    
    /// The amount of items you get per page
    public let itemsPerPage: Int?
}

/// The model for an Artist object from the Setlist.fm API
public struct FMArtist: Decodable, Equatable {
    /// Unique Musicbrainz Identifier (MBID), e.g. "b10bbbfc-cf9e-42e0-be17-e2c3e1d2600d"
    public let mbid: String?
    
    /// Unique Ticket Master Identifier (TMID), e.g. 735610
    public let tmid: Int?
    
    /// The artist's name, e.g. "The Beatles"
    public let name: String?
    
    /// The artist's sort name, e.g. "Beatles, The" or "Springsteen, Bruce"
    public let sortName: String?
    
    /// Disambiguation to distinguish between artists with same names
    public let disambiguation: String?
    
    /// The attribution url
    public let url: String?
}

/// The model for a Country object from the Setlist.fm API
public struct FMCountriesResult: Decodable, Equatable {
    /// Result list of countries
    public let country: [FMCountry]?
    
    /// The total amount of items matching the query
    public let total: Int?
    
    /// The current page, starts at 1
    public let page: Int?
    
    /// The amount of items you get per page
    public let itemsPerPage: Int?
}

/// The model for a Country object from the Setlist.fm API
public struct FMCountry: Decodable, Equatable {
    /// The country's [ISO code](http://www.iso.org/iso/english_country_names_and_code_elements). E.g. "ie" for Ireland
    public let code: String?
    
    /// The country's name
    /// Can be a localized name - e.g. "Austria" or "Österreich" for Austria if the German name was requested
    public let name: String?
}

/// The model for a Coords object from the Setlist.fm API
public struct FMCoords: Decodable, Equatable {
    /// The latitude part of the coordinates
    public let lat: Double?
    
    /// The longitude part of the coordinates
    public let long: Double?
}

/// The model for a Setlist.fm API request containing multiple cities
public struct FMCitiesResult: Decodable, Equatable {
    /// Result list of cities
    public let cities: [FMCity]?
    
    /// The total amount of items matching the query
    public let total: Int?
    
    /// The current page. starts at 1
    public let page: Int?
    
    /// The amount of items you get per page
    public let itemsPerPage: Int?
}

/// The model for a City object from the Setlist.fm API
public struct FMCity: Decodable, Equatable {
    /// Unique identifier.
    public let id: String?
    
    /// The city's name, depending on the language valid values are e.g. "Müchen" or Munich
    public let name: String?
    
    /**
     The code of the city's state.
     
     For most countries this is a two-digit numeric code, with which the state can be identified uniquely
     in the specific Country. The code can also be a String for other cities. Valid examples are "CA" or "02"
     which in turn get uniquely identifiable when combined with the state's country:
     
     "US.CA" for California, United States or "DE.02" for Bavaria, Germany
     
     For a complete list of available states (that aren't necessarily used in this database)
     is available in [a textfile on geonames.org](http://download.geonames.org/export/dump/admin1CodesASCII.txt).
     
     Note that this code is only unique combined with the city's Country. The code alone is **not** unique.
    */
    public let stateCode: String?
    
    /// The name of city's state, e.g. "Bavaria" or "Florida"
    public let state: String?
    
    /// The city's coordinates. Usually the coordinates of the city centre are used.
    public let coords: FMCoords?
    
    /// The city's country
    public let country: FMCountry?
}

/// The response model for a Setlist.fm API request containing multiple venues
public struct FMVenuesResult: Decodable, Equatable {
    // Result list of venue
    public let venue: [FMVenue]?
    
    /// The total amount of items matching the query
    public let total: Int?
    
    /// The current page. Starts at 1.
    public let page: Int?
    
    /// The amount of items you get per page
    public let itemsPerPage: Int?
}

/// The model for a Venue object from the Setlist.fm API
public struct FMVenue: Decodable, Equatable {
    /// The city in which the venue is located
    public let city: FMCity?
    
    /// The attribution url
    public let url: String?
    
    /// Unique identifier
    public let id: String?
    
    /// The name of the venue, usually without city and country. E.g. "Madison Square Garden" or "Royal Albert Hall"
    public let name: String?
}

/// The model for a Tour object from the Setlist.fm API
public struct FMTour: Decodable, Equatable {
    /// The name of the tour.
    public let name: String?
}

/// The model for a Song object from the Setlist.fm API
public struct FMSong: Decodable, Equatable {
    /// The name of the song. E.g. Yesterday or "Wish You Were Here"
    public let name: String?
    
    /// A different `FMArtist` than the performing one that joined the stage for this song
    public let with: FMArtist?
    
    /// The original `FMArtist` of this song, if different to the performing artist
    public let cover: FMArtist?
    
    /// Special incidents or additional information about the way the song was performed at this specific concert.
    /// See the [setlist.fm guidelines](https://www.setlist.fm/guidelines) for a complete list of allowed content.
    public let info: String?
    
    /// The song came from tape rather than being performed live.
    /// See the [tape section of the guidelines](https://www.setlist.fm/guidelines#tape-songs) for valid usage.
    public let tape: Bool?
}

/// The model for a Set object from the Setlist.fm API
public struct FMSet: Decodable, Equatable {
    /// The description/name of the set. E.g. "Acoustic set" or "Paul McCartney solo"
    public let name: String?
    
    /// If the set is an encore, this is the number of the encore,
    /// starting with 1 for the first encore, 2 for the second and so on
    public let encore: Int?
    
    /// This set's songs
    public let song: [FMSong]?
}

/// The model for a User object from the Setlist.fm API
public struct FMUser: Decodable, Equatable {
    /// Unqiue identifier
    public let userId: String?
    
    /// The fullname of the user, which can contain their first, middle, and last name
    public let fullname: String?
    
    /// The url to the user's LastFM profile page
    public let lastFM: String?
    
    /// The url to the user's Myspace profile page
    public let mySpace: String?
    
    /// The url to the user's Twitter profile page
    public let twitter: String?
    
    /// The url to the user's Flickr profile page
    public let fickr: String?
    
    /// The url to the user's personal website
    public let website: String?
    
    /// A description of the user, provided by the user
    public let about: String?
    
    /// The url to the user's profile page on Setlist.fm
    public let url: String?
}

//
//  SpotifyCaseTypes.swift
//  Vibez
//
//  Created by Benjamin Simpson on 12/5/20.
//

import Foundation

enum SpotifyCaseTypes: String {
    case artist = "artist"
    case album = "album"
    case show = "show"
    case playlist = "playlist"
    case track = "track"
    case episode = "episode"
}

enum UserFavoriteAristTypes: String {
    case tracks = "tracks"
    case artists = "artists"
}

enum Country: String {
    case US = "US"
    case UK = "UK"
}

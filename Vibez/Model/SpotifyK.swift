//
//  SpotifyK.swift
//  Vibez
//
//  Created by Benjamin Simpson on 12/4/20.
//

import Foundation

struct Key {
    static let SPOTIFY_API_CLIENT_ID = "af7a2e9160d049e49838dd8e496a2955"
    static let SPOTIFY_API_CLIENT_SECRET = "08b0f9ddb9e94716aadb3af2a3857910"
    static let REDIRECT_URI = "Vibez://"
    static let USER_SCOPES = ["user-read-email", "user-top-read"]
    static let RESPONSE_TYPE = "code"
}

enum SpotifyURL: String {
    case authBaseURL = "https://accounts.spotify.com/api/"
    case APICallBase = "https://api.spotify.com/v1/"
}

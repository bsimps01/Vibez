//
//  NetworkCalls.swift
//  Vibez
//
//  Created by Benjamin Simpson on 12/6/20.
//

import Foundation

enum Parameters {
    case tokenRefreshCode(refreshToken: String)
    case durationOfTime(duration: String)
    case tokenCode(accessCode: String)
    
    func constructParameters() -> [String:Any] {
        switch self {
        case .tokenCode(let code):
            return ["grant_type": "authorization_code",
                    "redirect_uri": Key.REDIRECT_URI,
                    "code": "\(code)"]
        case .durationOfTime(let duration):
            return ["time_duration": duration]
            
        case .tokenRefreshCode(let refreshToken):
            return ["grant_type": "refresh_token",
                    "refresh_token": refreshToken
            ]
        }
    }
    
enum Header {
    case GETHeader(accessToken: String)
    case POSTHeader
        
    func buildHeader() -> [String:String] {
        switch self {
        case .GETHeader (let accessToken):
            return ["Accept": "application/json",
                        "Content-Type": "application/json",
                        "Authorization": "Bearer \(accessToken)"
                ]
        case .POSTHeader:
                // Spotify's required format for authorization
            let SPOTIFY_API_AUTH_KEY = "Basic \((Key.SPOTIFY_API_CLIENT_ID + ":" + Key.SPOTIFY_API_CLIENT_SECRET).data(using: .utf8)!.base64EncodedString())"
            return ["Authorization": SPOTIFY_API_AUTH_KEY,
                        "Content-Type": "application/x-www-form-urlencoded"]
            }
        }
    }
    
enum EndingPath {
    case userInfo
    case userFavoriteArtists(type: UserFavoriteAristTypes)
    case artist(id: String)
    case artists(ids: [String])
    case artistTopSongs(artistId: String, country: Country)
    case search(q: String, type: SpotifyCaseTypes)
    case playlist(id: String)
    case songs(ids: [String])
    case token

        func buildPath() -> String {
            switch self {
            case .token:
                return "token"
                
            case .userInfo:
                return "me"
                
            case .userFavoriteArtists(let type):
                return "user/top/\(type)"
                
            case .artist(let id):
                return "artist/\(id)"
                
            case .artists (let ids):
                return "artists&ids=\(ids.joined(separator: ","))"
                
            case .search(let q, let type):
                let convertSpacesToProperURL = q.replacingOccurrences(of: " ", with: "%20")
                return "search?q=\(convertSpacesToProperURL)&type=\(type)"
                
            case .artistTopSongs(let id, let country):
                return "artists/\(id)/top-tracks?country=\(country)"
                
            case .playlist (let id):
                return "playlists/\(id)"
                
            case .songs(let ids):
                return "tracks/?ids=\(ids.joined(separator: ","))"
            }
        }


    }
    
    
    
    
}

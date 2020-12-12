//
//  DataModel.swift
//  Vibez
//
//  Created by Benjamin Simpson on 12/5/20.
//

import Foundation


///UserInfo

struct UserModel: JSONModel {
    let displayName: String
    let email: String
}

struct UserFavoriteArtists: JSONModel {
    let items: [ArtistItem]
}

struct UserTopSongs: JSONModel {
    let items: [Album]
}

struct UserFavoriteSongs: JSONModel {
    let items: [Album]
}


///Artists

struct Artist: JSONModel {
    let name: String
    let type: String
}

struct ArtistItem: JSONModel {
    let id: String
    let name: String
    let images: [ArtistImage]
}

struct ArtistImage: JSONModel {
    let height: Int
    let url: URL
}

///Songs

struct ArtistTopSongs: JSONModel {
    let tracks: [ArtistSong]
}

struct ArtistSong: JSONModel {
    let id: String
    let name: String
    let previewUrl: URL?
    let album: Album
}

struct Track: JSONModel {
    let items: [Item]
}

struct Item: JSONModel {
    let track: Album
}

struct Album: JSONModel {
    let id: String
    let album: AlbumInfo?
    let name: String
    let artists: [Artist]
    let images: [ArtistImage]?
    let previewUrl: URL?
    let durationMs: Int?
}

struct AlbumInfo: JSONModel {
    let name: String
    let images: [ArtistImage]
}

struct Playlist: JSONModel {
    let name: String
    let images: [PlaylistImage]
    let tracks: Track
}

struct PlaylistImage: JSONModel {
    let url: URL
}

///SearchResults

struct SearchArtists: JSONModel {
    let artists: Artists
}

struct SearchSongs: JSONModel {
    let songs: Songs
}

struct Artists: JSONModel {
    let items: [ArtistItem]
}

struct Songs: JSONModel {
    let items: [ArtistSong]
}

/// Tokens

struct Tokens: JSONModel {
    let accessToken: String
    let expiresIn: Int
    let scope: String?
    let refreshToken: String?
}

struct ExpiredToken: JSONModel {
    let error: ErrorMessage
   
}

struct ErrorMessage: JSONModel {
    let status: Int?
    let message: String?
}



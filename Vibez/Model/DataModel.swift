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

struct FavoriteArtists: JSONModel {
    let items: [ArtistObject]
}

struct UserTopSongs: JSONModel {
    let items: [Album]
}

struct FavoriteSongs: JSONModel {
    let items: [Album]
}


///Artists

struct Artist: JSONModel {
    let name: String
    let type: String
}

struct ArtistObject: JSONModel {
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
    let songs: [ArtistSong]
}

struct Song: JSONModel {
    let items: [Item]
}

struct Item: JSONModel {
    let song: Album
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
    let songs: Song
}

struct PlaylistImage: JSONModel {
    let url: URL
}

struct ArtistSong: JSONModel {
    let id: String
    let name: String
    let previewUrl: URL?
    let album: Album
}

///SearchResults

struct SearchArtists: JSONModel {
    let artists: Artists
}

struct SearchSongs: JSONModel {
    let songs: Songs
}

struct Artists: JSONModel {
    let items: [ArtistObject]
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



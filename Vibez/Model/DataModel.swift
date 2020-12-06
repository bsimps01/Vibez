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



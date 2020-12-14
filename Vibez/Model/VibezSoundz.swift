//
//  VibezSoundz.swift
//  Vibez
//
//  Created by Benjamin Simpson on 12/4/20.
//

import Foundation

struct VibezSoundz {
    let id: String
    let title: String
    let artistName: String?
    let previewUrl: URL?
    let images: [ArtistImage]
    
    init(artistName: String?, id: String, title: String, previewURL: URL?, images: [ArtistImage]) {
        self.artistName = artistName
        self.id = id
        self.title = title
        self.images = images
        self.previewUrl = previewURL
    }
}



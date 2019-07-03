//
//  Media.swift
//  Outlet
//
//  Created by Dominick Hera on 7/2/19.
//  Copyright © 2019 Dominick Hera. All rights reserved.
//

import Foundation

struct Media {
    let coverPhotoURL: String
    let downloadURL: String
    let trackingLink: String
    let mediaType: String
    
    init(coverPhotoURL: String, downloadURL: String, trackingLink: String, mediaType: String) {
        self.coverPhotoURL = coverPhotoURL
        self.downloadURL = downloadURL
        self.trackingLink = trackingLink
        self.mediaType = mediaType
    }
}

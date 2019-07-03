//
//  Campaign.swift
//  Outlet
//
//  Created by Dominick Hera on 7/2/19.
//  Copyright © 2019 Dominick Hera. All rights reserved.
//

import Foundation

struct Campaign {
    let id: Int
    let name: String
    let iconURL: String
    let payPerInstall: String
    let medias: [Media]
    
    init(id: Int, name: String, iconURL: String, payPerInstall: String, medias: [Media]) {
        self.id = id
        self.name = name
        self.iconURL = iconURL
        self.payPerInstall = payPerInstall
        self.medias = medias
    }
}

//
//  DownloadManager.swift
//  Outlet
//
//  Created by Dominick Hera on 7/2/19.
//  Copyright © 2019 Dominick Hera. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class DownloadManager {
    
    static let shared = DownloadManager()
    var campaignList: [Campaign] = []
    
    private init() {}
    
    func initCampaignList(callback: @escaping(_ error: Error?) -> Void ) {
        let url = "http://www.plugco.in/public/take_home_sample_feed"
        Alamofire.request(url, method: .get,encoding: URLEncoding.httpBody)
            .responseJSON { response in
                response.result.ifSuccess {
                    let ResponseList = JSON(response.value!)
                    let realResponseList = ResponseList["campaigns"]
                    for i in 0...realResponseList.count-1 {
                        let tempId = realResponseList[i]["id"].int
                        let tempName = realResponseList[i]["campaign_name"].string
                        let tempIconURL = realResponseList[i]["campaign_icon_url"].string
                        let tempPayPerInstall = realResponseList[i]["pay_per_install"].string
                        var mediaList: [Media] = []
                        for k in 0...realResponseList[i]["medias"].count-1 {
                            let tempMedia = realResponseList[i]["medias"][k]
                            let tempCoverPhotoURL = tempMedia["cover_photo_url"].string
                            let tempDownloadURL = tempMedia["download_url"].string
                            let tempMediaType = tempMedia["media_type"].string
                            let tempTrackingLink = tempMedia["tracking_link"].string
                            let newMedia = Media(coverPhotoURL: tempCoverPhotoURL!, downloadURL: tempDownloadURL!, trackingLink: tempTrackingLink!, mediaType: tempMediaType!)
                            mediaList.append(newMedia)
                        }
                        
                        let newCampaign = Campaign(id: tempId!, name: tempName!, iconURL: tempIconURL!, payPerInstall: tempPayPerInstall!, medias: mediaList)
                        self.campaignList.append(newCampaign)
                       
                    }
                }
                callback(nil)
        }
    }
}

//
//  CampaignMediaCollectionViewCell.swift
//  Outlet
//
//  Created by Dominick Hera on 7/2/19.
//  Copyright © 2019 Dominick Hera. All rights reserved.
//

import UIKit
import Kingfisher

protocol MediaDelegate {
    func downloadMedia(downloadURL: String)
    func copyMediaLink(mediaLink: String)
}
class CampaignMediaCollectionViewCell: UICollectionViewCell {
    var delegate: MediaDelegate?
    @IBOutlet weak var coverPhotoImageView: UIImageView!
    @IBOutlet weak var copyLinkView: UIView!
    @IBOutlet weak var downloadMediaView: UIView!
    @IBOutlet weak var totalButtonView: UIView!
    @IBOutlet weak var videoMediaBlurView: UIVisualEffectView!
    
    
    var tempMedia: Media!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.totalButtonView.layer.cornerRadius = 10
        self.coverPhotoImageView.layer.cornerRadius = 7
        self.videoMediaBlurView.layer.cornerRadius = 7
        self.totalButtonView.layer.borderWidth = 1.0
        self.totalButtonView.layer.borderColor = UIColor.lightGray.cgColor
        self.copyLinkView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(callCopyLink)))
        self.downloadMediaView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(callDownloadLink)))

        // Initialization code
    }
    
    func initializeMedia(media: Media) {
        tempMedia = media
        let tempURL = URL(string: media.coverPhotoURL)
        self.coverPhotoImageView.kf.setImage(with: tempURL)
        if (media.mediaType == "video") {
            self.videoMediaBlurView.isHidden = false
        } else {
            self.videoMediaBlurView.isHidden = true
        }
    }
    
    @objc func callCopyLink(){
        copyLinkToMedia(Any.self)
    }
    
    @objc func callDownloadLink(){
        downloadMediaFile(Any.self)
    }
    
}

extension CampaignMediaCollectionViewCell {
    @IBAction func downloadMediaFile(_ sender: Any) {
        delegate?.downloadMedia(downloadURL: tempMedia.downloadURL)
    }
    
    @IBAction func copyLinkToMedia(_ sender: Any) {
        delegate?.copyMediaLink(mediaLink: tempMedia.trackingLink)
    }
}

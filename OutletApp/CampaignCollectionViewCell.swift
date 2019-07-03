//
//  CampaignCollectionViewCell.swift
//  Outlet
//
//  Created by Dominick Hera on 7/2/19.
//  Copyright © 2019 Dominick Hera. All rights reserved.
//

import UIKit
import Kingfisher
import Photos
import PhotosUI

protocol NotificationDelegate {
    func showSuccessAlert()
    func showCopiedAlert()
}

class CampaignCollectionViewCell: UICollectionViewCell {
    var delegate: NotificationDelegate?
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var campaignIconImageView: UIImageView!
    @IBOutlet weak var campaignNameLabel: UILabel!
    @IBOutlet weak var campaignRewardLabel: UILabel!
    private let itemHeight: CGFloat = 230
    private let lineSpacing: CGFloat = 15
    private let itemWidth: CGFloat = 100
    private let xInset: CGFloat = 15
    private let topInset: CGFloat = 15
    let cellPercentWidth: CGFloat = 1.0
    var campaignCellIdentifier = "CampaignMediaCollectionViewCell"
    var tempCampaign: Campaign!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let campaignNib = UINib(nibName: campaignCellIdentifier, bundle: nil)
        collectionView.register(campaignNib, forCellWithReuseIdentifier: campaignCellIdentifier)
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        layout.minimumLineSpacing = lineSpacing
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        self.campaignIconImageView.layer.cornerRadius = 15
    }
    
    func initializeCell(campaign: Campaign) {
        tempCampaign = campaign
        self.campaignNameLabel.text = campaign.name
        
        let boldAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]
        let boldRewardString = NSMutableAttributedString(string: campaign.payPerInstall, attributes: boldAttributes)
        let normalRewardString = NSMutableAttributedString(string: " per Install")
        boldRewardString.append(normalRewardString)
        self.campaignRewardLabel.attributedText = boldRewardString
        let tempURL = URL(string: campaign.iconURL)
        self.campaignIconImageView.image = nil
        self.campaignIconImageView.kf.setImage(with: tempURL)

    }
    
}

extension CampaignCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, MediaDelegate {
    func downloadMedia(downloadURL: String) {
        DispatchQueue.global(qos: .background).async {
            if let url = URL(string: downloadURL),
                let urlData = NSData(contentsOf: url) {
                let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
                let filePath="\(documentsPath)/\(self.tempCampaign.name).mp4"
                DispatchQueue.main.async {
                    urlData.write(toFile: filePath, atomically: true)
                    PHPhotoLibrary.shared().performChanges({
                        PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(fileURLWithPath: filePath))
                    }) { completed, error in
                        if completed {
                            DispatchQueue.main.async {
                            self.triggerSuccessAlert(Any.self)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func copyMediaLink(mediaLink: String) {
        UIPasteboard.general.string = mediaLink
        self.triggerCopiedAlert(Any.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tempCampaign.medias.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: campaignCellIdentifier, for: indexPath) as! CampaignMediaCollectionViewCell
        cell.delegate = self
        if (indexPath.row < tempCampaign.medias.count){
            cell.initializeMedia(media: tempCampaign.medias[indexPath.row])
        }
        return cell
    }
    
    @IBAction func triggerSuccessAlert(_ sender: Any) {
        delegate?.showSuccessAlert()
    }
    
    @IBAction func triggerCopiedAlert(_ sender: Any) {
        delegate?.showCopiedAlert()
    }
    
}

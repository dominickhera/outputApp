//
//  ViewController.swift
//  Outlet
//
//  Created by Dominick Hera on 7/2/19.
//  Copyright © 2019 Dominick Hera. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private let itemHeight: CGFloat = 351
    private let lineSpacing: CGFloat = 1
    private let xInset: CGFloat = 0
    private let topInset: CGFloat = 0
    let cellPercentWidth: CGFloat = 1.0
    var campaignCellIdentifier = "CampaignCollectionViewCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        let campaignNib = UINib(nibName: campaignCellIdentifier, bundle: nil)
        collectionView.register(campaignNib, forCellWithReuseIdentifier: campaignCellIdentifier)
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        layout.minimumLineSpacing = lineSpacing
        let itemWidth = ( UIScreen.main.bounds.width)
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        DownloadManager.shared.initCampaignList() { error in
            self.collectionView.reloadData()
        }
        self.collectionView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, NotificationDelegate {
    func showSuccessAlert() {
        let alert = UIAlertController(title: "Saved", message: "Your video has been successfully saved", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showCopiedAlert() {
        let alert = UIAlertController(title: "Copied", message: "The link to the content has been copied to your clipboard!", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DownloadManager.shared.campaignList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: campaignCellIdentifier, for: indexPath) as! CampaignCollectionViewCell
        cell.delegate = self
        cell.initializeCell(campaign: DownloadManager.shared.campaignList[indexPath.row])
        return cell
    }
}


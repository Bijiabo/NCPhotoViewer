//
//  AlbumListTableViewController.swift
//  NCPhotoViewer
//
//  Created by huchunbo on 16/1/21.
//  Copyright © 2016年 Bijiabo. All rights reserved.
//

import UIKit
import Photos

class AlbumListTableViewController: UITableViewController {
    
    var moments: PHFetchResult?
    var albums: PHFetchResult?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        _setupViews()
        _setupAlbumData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func _setupViews() {
        let tableFooterView: UIView = UIView()
        tableFooterView.backgroundColor = UIColor.clearColor()
        tableView.tableFooterView = tableFooterView
        
        clearsSelectionOnViewWillAppear = false
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 1 // moments == nil ? 0 : moments!.count
        default:
            return albums == nil ? 0 : albums!.count
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("albumListCell", forIndexPath: indexPath) as! AlbumListTableViewCell
            let currentData = moments?.objectAtIndex(indexPath.row) as? PHAssetCollection
            
            cell.titleLabel.text = currentData?.localizedLocationNames.count > 0 ? currentData?.localizedLocationNames[0] : "Moments"
            
            let assets = PHAsset.fetchAssetsInAssetCollection(currentData!, options: nil)
            
            cell.count = assets.count
            
            let targetSize = CGSize(width: 120.0, height: 120.0)
            PHImageManager.defaultManager().requestImageForAsset(assets.lastObject as! PHAsset, targetSize: targetSize, contentMode: PHImageContentMode.AspectFill, options: nil, resultHandler: { (image, info: [NSObject : AnyObject]?) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    cell.previewImage0 = image!
                })
                
            })
            
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("albumListCell", forIndexPath: indexPath) as! AlbumListTableViewCell
            let currentData = albums?.objectAtIndex(indexPath.row) as? PHAssetCollection
            
            cell.titleLabel.text = currentData?.localizedTitle
            
            let assets = PHAsset.fetchAssetsInAssetCollection(currentData!, options: nil)
            
            cell.count = assets.count
            
            let targetSize = CGSize(width: 120.0, height: 120.0)
            PHImageManager.defaultManager().requestImageForAsset(assets.lastObject as! PHAsset, targetSize: targetSize, contentMode: PHImageContentMode.AspectFill, options: nil, resultHandler: { (image, info: [NSObject : AnyObject]?) -> Void in
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    cell.previewImage0 = image!
                })
                
            })
            
            cell.assetCollection = currentData
            
            return cell
        }

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let segueIdentifier = segue.identifier else {return}
        switch segueIdentifier {
        case "linkToPreviewCollectionView":
            guard let targetVC = segue.destinationViewController as? PreviewCollectionViewController else {return}
            guard let cell = sender as? AlbumListTableViewCell else {return}
            targetVC.assetsCollection = cell.assetCollection
        default:
            break
        }
    }

}

// MARK: - load data

extension AlbumListTableViewController {
    
    private func _setupAlbumData() {
        // get albums
        let userAlbumsOptions: PHFetchOptions = PHFetchOptions()
        userAlbumsOptions.predicate = NSPredicate(format: "estimatedAssetCount > 0", argumentArray: nil)
        let userAlbums: PHFetchResult = PHAssetCollection.fetchAssetCollectionsWithType(PHAssetCollectionType.Album, subtype: PHAssetCollectionSubtype.Any, options: userAlbumsOptions)
        albums = userAlbums
        
        // get moments
        let userMomentsOptions: PHFetchOptions = PHFetchOptions()
        userAlbumsOptions.predicate = NSPredicate(format: "estimatedAssetCount > 0", argumentArray: nil)
        let userMoments: PHFetchResult = PHAssetCollection.fetchAssetCollectionsWithType(PHAssetCollectionType.Moment, subtype: PHAssetCollectionSubtype.AlbumRegular, options: userMomentsOptions)
        moments = userMoments
    }
    
}

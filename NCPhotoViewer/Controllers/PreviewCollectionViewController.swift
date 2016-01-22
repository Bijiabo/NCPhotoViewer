//
//  PreviewCollectionViewController.swift
//  NCPhotoViewer
//
//  Created by huchunbo on 16/1/21.
//  Copyright © 2016年 Bijiabo. All rights reserved.
//

import UIKit
import Photos

private let reuseIdentifier = "photoCell"
private let numberOfCellsInLine: Int = 5
private let cellSpacing: CGFloat = 4.0

class PreviewCollectionViewController: UICollectionViewController {
    
    var momentMode: Bool = false
    var assetsCollection: PHAssetCollection?
    var data: PHFetchResult!
    var subData: [PHFetchResult] = [PHFetchResult]()
    let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        _setupData()
        
        // setup flow layout
        flowLayout.itemSize = CGSize(width: 100, height: 100)
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Vertical
        flowLayout.minimumInteritemSpacing = cellSpacing
        flowLayout.minimumLineSpacing = cellSpacing
        flowLayout.sectionInset = UIEdgeInsets(top: cellSpacing, left: cellSpacing, bottom: cellSpacing, right: cellSpacing)
        if momentMode {
            flowLayout.headerReferenceSize = CGSize(width: view.frame.width, height: 50.0)
            flowLayout.sectionHeadersPinToVisibleBounds = true
        }
        collectionView?.collectionViewLayout = flowLayout

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if momentMode {
            return data.count
        } else {
            return 1
        }
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if momentMode {
            return subData[section].count
        } else {
            return data.count
        }
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! PreviewPhotoCollectionViewCell
        let currentAsset = momentMode ? subData[indexPath.section].objectAtIndex(indexPath.row) as! PHAsset : data.objectAtIndex(indexPath.row) as! PHAsset
        
        let targetSize = CGSize(width: 120.0, height: 120.0)
        PHImageManager.defaultManager().requestImageForAsset(currentAsset, targetSize: targetSize, contentMode: PHImageContentMode.AspectFill, options: nil, resultHandler: { (image, info: [NSObject : AnyObject]?) -> Void in
            guard let image = image else {return}
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                cell.image = image
            })
            
        })
    
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "previewHeaderCell", forIndexPath: indexPath) as! PreviewHeaderCollectionReusableView
            if let currentCollection = data.objectAtIndex(indexPath.section) as? PHAssetCollection {
                let startDateString: String = currentCollection.startDate == nil ? "" : _formatDate(currentCollection.startDate!)
                let endDateString: String = currentCollection.endDate == nil ? "" : _formatDate(currentCollection.endDate!)
                let collectionName = currentCollection.localizedLocationNames.count > 0 ? currentCollection.localizedLocationNames.first : currentCollection.localizedTitle
                if let collectionName = collectionName {
                    headerView.title = startDateString.isEmpty || endDateString.isEmpty ? collectionName : "\(collectionName) (\(startDateString) - \(endDateString))"
                } else {
                    headerView.title = startDateString.isEmpty || endDateString.isEmpty ? "Moment" : "\(startDateString) - \(endDateString)"
                }
            }
            
            return headerView
        }
        
        let reusableView: UICollectionReusableView! = nil
        return reusableView
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let segueIdentifier = segue.identifier else {return}
        switch segueIdentifier {
        case "linkToBrowse":
            guard let targetVC = segue.destinationViewController as? BrowseCollectionViewController else {return}
            guard let cell = sender as? PreviewPhotoCollectionViewCell else {return}
            guard let indexPath = collectionView?.indexPathForCell(cell) else {return}
            if momentMode {
                targetVC.assetsCollection = data.objectAtIndex(indexPath.section) as? PHAssetCollection
                targetVC.startIndexPath = NSIndexPath(forRow: indexPath.row, inSection: 0)
            } else {
                targetVC.assetsCollection = assetsCollection
                targetVC.startIndexPath = indexPath
            }
        default:
            break
        }
    }
    
    private func _formatDate(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        return dateFormatter.stringFromDate(date)
    }

}

// MARK: - data functions

extension PreviewCollectionViewController {
    
    private func _setupData() {
        if momentMode {
            let userMomentsOptions: PHFetchOptions = PHFetchOptions()
            userMomentsOptions.predicate = NSPredicate(format: "estimatedAssetCount > 0", argumentArray: nil)
            let userMoments: PHFetchResult = PHAssetCollection.fetchAssetCollectionsWithType(PHAssetCollectionType.Moment, subtype: PHAssetCollectionSubtype.AlbumRegular, options: userMomentsOptions)
            data = userMoments
            
            var subDataCache: [PHFetchResult] = [PHFetchResult]()
            data.enumerateObjectsUsingBlock({ (collection, index, stop) -> Void in
                let fetchOptions = PHFetchOptions()
                fetchOptions.sortDescriptors = [
                    NSSortDescriptor(key: "creationDate", ascending: true)
                ]
                subDataCache.append( PHAsset.fetchAssetsInAssetCollection(collection as! PHAssetCollection, options: fetchOptions) )
            })
            subData = subDataCache
            
        } else {
            guard let assetsCollection = assetsCollection else {return}
            
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [
                NSSortDescriptor(key: "creationDate", ascending: true)
            ]
            data = PHAsset.fetchAssetsInAssetCollection(assetsCollection, options: fetchOptions)
        }
    }
}

// MARK: - flow layout delegate

extension PreviewCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let x = (view.frame.size.width - CGFloat(numberOfCellsInLine + 2) * flowLayout.minimumLineSpacing  ) / CGFloat(numberOfCellsInLine)
        return CGSize(width: x, height: x)
    }
    /*
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let x: CGFloat = 4.0
        return UIEdgeInsets(top: x, left: x, bottom: x, right: x)
    }
    */
}

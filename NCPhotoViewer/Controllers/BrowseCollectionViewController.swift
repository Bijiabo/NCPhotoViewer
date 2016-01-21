//
//  BrowseCollectionViewController.swift
//  NCPhotoViewer
//
//  Created by huchunbo on 16/1/22.
//  Copyright © 2016年 Bijiabo. All rights reserved.
//

import UIKit
import Photos

private let reuseIdentifier = "browseCell"
private let cellSpacing: CGFloat = 0

class BrowseCollectionViewController: UICollectionViewController {

    var assetsCollection: PHAssetCollection?
    var data: PHFetchResult!
    let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    var startIndexPath: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _setupData()

        // setup flow layout
        flowLayout.itemSize = CGSize(width: 100, height: 100)
        flowLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        flowLayout.minimumInteritemSpacing = cellSpacing
        flowLayout.minimumLineSpacing = cellSpacing
        flowLayout.sectionInset = UIEdgeInsets(top: cellSpacing, left: cellSpacing, bottom: cellSpacing, right: cellSpacing)
        collectionView?.collectionViewLayout = flowLayout
        
        collectionView?.pagingEnabled = true
        collectionView?.contentInset = UIEdgeInsetsZero
        automaticallyAdjustsScrollViewInsets = false
        
        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false
        
        if let startIndexPath = startIndexPath {
            collectionView?.scrollToItemAtIndexPath(startIndexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: false)
        }

        // Register cell classes
        // self.collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateNavigationBarDisplay(display: false)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        updateNavigationBarDisplay(display: true)
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
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return data.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! BrowseCollectionViewCell
        let currentData = data.objectAtIndex(indexPath.row) as! PHAsset
        let targetSize = CGSize(width: 120.0, height: 120.0)
        PHImageManager.defaultManager().requestImageForAsset(currentData, targetSize: targetSize, contentMode: PHImageContentMode.AspectFill, options: nil, resultHandler: { (image, info: [NSObject : AnyObject]?) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                cell.image = image!
            })
            
        })
        
        if let creationDate = currentData.creationDate {
            cell.date = creationDate
        }
        cell.width = currentData.pixelWidth
        cell.height = currentData.pixelHeight
        
        cell.browseDelegate = self
    
        return cell
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

    func toggleNavigationBarDisplay() {
        if navigationController?.navigationBar.alpha == 0 {
            updateNavigationBarDisplay(display: true)
        } else {
            updateNavigationBarDisplay(display: false)
        }
    }
    
    func updateNavigationBarDisplay(display display: Bool) {
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
            self.navigationController?.navigationBar.alpha = display ? 1.0 : 0.0
            }, completion: nil)
    }
}

// MARK: - data functions

extension BrowseCollectionViewController {
    
    private func _setupData() {
        guard let assetsCollection = assetsCollection else {return}
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: true)
        ]
        data = PHAsset.fetchAssetsInAssetCollection(assetsCollection, options: fetchOptions)
        print(data.count)
    }
}

// MARK: - flow layout delegate

extension BrowseCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    /*
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
    let x: CGFloat = 4.0
    return UIEdgeInsets(top: x, left: x, bottom: x, right: x)
    }
    */
}

extension BrowseCollectionViewController: BrowsePhotoDelegate {
    
    func tapPreviewView() {
        toggleNavigationBarDisplay()
    }
    
}



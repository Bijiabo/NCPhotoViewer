//
//  BrowseCollectionViewCell.swift
//  NCPhotoViewer
//
//  Created by huchunbo on 16/1/22.
//  Copyright © 2016年 Bijiabo. All rights reserved.
//

import UIKit

class BrowseCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    
    var browseDelegate: BrowsePhotoDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("tapCell:")))
    }
    
    func tapCell(sender: UITapGestureRecognizer) {
        browseDelegate?.tapPreviewView()
    }
    
    var width: Int = 0 {
        didSet {
            _updateSizeInformation()
        }
    }
    
    var height: Int = 0 {
        didSet {
            _updateSizeInformation()
        }
    }
    
    private func _updateSizeInformation() {
        let sizeString: String = "\(width) ✕ \(height)"
        sizeLabel.text = sizeString
    }
    
    var date: NSDate = NSDate() {
        didSet {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-dd-MM"
            dateLabel.text = dateFormatter.stringFromDate(date)
        }
    }
    
    var image: UIImage = UIImage() {
        didSet {
            imageView.image = image
        }
    }
}

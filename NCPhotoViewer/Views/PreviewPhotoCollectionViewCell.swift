//
//  PreviewPhotoCollectionViewCell.swift
//  NCPhotoViewer
//
//  Created by huchunbo on 16/1/21.
//  Copyright © 2016年 Bijiabo. All rights reserved.
//

import UIKit

class PreviewPhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var image: UIImage = UIImage() {
        didSet {
            imageView.image = image
        }
    }
}

//
//  PreviewHeaderCollectionReusableView.swift
//  NCPhotoViewer
//
//  Created by huchunbo on 16/1/22.
//  Copyright © 2016年 Bijiabo. All rights reserved.
//

import UIKit

class PreviewHeaderCollectionReusableView: UICollectionReusableView {
        
    @IBOutlet weak var titleLabel: UILabel!
    
    var title: String = String() {
        didSet {
            titleLabel.text = title
        }
    }
}

//
//  LoopCollectionViewCell.swift
//  Animeloop
//
//  Created by ShinCurry on 2017/11/21.
//  Copyright © 2017年 ShinCurry. All rights reserved.
//

import UIKit
import Kingfisher

class LoopCollectionViewCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        loopImageView.needsPrescaling = false
        loopImageView.kf.indicatorType = .activity
        (loopImageView.kf.indicator?.view as? UIActivityIndicatorView)?.color = .white
    }
    
    private var fileUrl: String?
    
    public var loopId: String? {
        didSet {
            fileUrl = "https://animeloop.org/files/gif_360p/\(loopId!).gif"
            let url = URL(string: fileUrl!)
            let resource = ImageResource(downloadURL: url!, cacheKey: "loop-id-\(loopId!)")
            
            loopImageView.kf.setImage(with: resource, placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
        }
    }
    
    @IBOutlet weak var loopImageView: AnimatedImageView!
}

//
//  LoopCollectionViewController.swift
//  Animeloop
//
//  Created by ShinCurry on 2017/11/21.
//  Copyright © 2017年 ShinCurry. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import RandomColorSwift
import Kingfisher

private let reuseIdentifier = "LoopCell"

class LoopCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.register(UINib(nibName: "LoopCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "LoopCell")
        
        setupUI()
        setupKingFihser()
        setupRefreshControl()
        
        refreshData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    var refreshControl = UIRefreshControl()
    
    private var loops: [JSON] = []
}

// MARK: UICollectionViewDataSource

extension LoopCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return loops.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! LoopCollectionViewCell
        
        let darkBlueColor = randomColor(hue: .value(200), luminosity: .dark)
        let id = loops[indexPath.row]["id"].stringValue
        cell.backgroundColor = darkBlueColor
        cell.loopId = id
        
        return cell
    }
}


// MARK: UICollectionViewDelegateFlowLayout

extension LoopCollectionViewController {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.bounds.size.width / 2
        let height = width * 9 / 16
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat()
    }
}

extension LoopCollectionViewController {
    func setupUI() {
        collectionView?.backgroundColor = randomColor(hue: .value(200), luminosity: .dark)
    }

    func setupKingFihser() {
        ImageCache.default.maxMemoryCost = 320 * 180 * 120
    }
    
    func setupRefreshControl() {
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        collectionView?.addSubview(refreshControl)
    }
}


// MARK: refreshData

extension LoopCollectionViewController {
    @objc func refreshData() {
        Alamofire.request("https://animeloop.org/api/v1/rand/loop/30").responseJSON { response in
            guard let data = response.result.value else {
                return
            }
            let json = JSON(data)
            if let loops = json["data"].array {
                loops.forEach { loop in
                    self.loops.insert(loop, at: 0)
                }
                while (self.loops.count > 120) {
                    self.loops.removeLast()
                }
                self.collectionView?.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
}

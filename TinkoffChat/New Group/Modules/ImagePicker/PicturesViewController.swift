//
//  PicturesViewController.swift
//  TinkoffChat
//
//  Created by e.a.morozova on 19.11.17.
//  Copyright © 2017 e.a.morozova. All rights reserved.
//

import Foundation
import UIKit

class PicturesViewController: UICollectionViewController {
    
    var model: PicturesViewModel?
    
    override func viewDidLoad() {
        model = PicturesViewModel()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.collectionView?.dequeueReusableCell(withReuseIdentifier: "image_cell", for: indexPath) as! ImageCell
            self.model?.getImage { (images) in
                if images.count > 0 {
                    cell.image = images.first
                }
            }
        
        return cell
    }
}

class ImageCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
    var image: UIImage? {
        get { return imageView.image }
        set {
            imageView.image = newValue
        }
    }
}

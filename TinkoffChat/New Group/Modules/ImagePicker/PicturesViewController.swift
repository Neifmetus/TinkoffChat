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
    
    let cellInRow = 3
    var model: PicturesViewModel?
    var imageUrls: [String] = []
    
    override func viewDidLoad() {
        self.collectionView?.backgroundColor = UIColor.darkGray
        
        model = PicturesViewModel()
        
        DispatchQueue.global(qos: .utility).async {
            self.model?.getImageUrls() { urls in
                self.imageUrls = urls
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            }
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 50
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.collectionView?.dequeueReusableCell(withReuseIdentifier: "image_cell", for: indexPath) as! ImageCell
       
        if self.imageUrls.count > 0 {
            let url = URL(string: self.imageUrls[indexPath.row])
            let data = try? Data(contentsOf: url!)

            if let image = UIImage(data: data!)?.crop(rect: CGRect(x: 0, y: 0, width: cell.imageView.frame.width, height: cell.imageView.frame.height)) {
                cell.image = image
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

extension PicturesViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.frame.size.width - 1 - CGFloat(cellInRow + 1) * CGFloat(10))/CGFloat(cellInRow)
        return CGSize(width: cellWidth, height: cellWidth)
    }
}

//
//  PicturesViewController.swift
//  TinkoffChat
//
//  Created by e.a.morozova on 19.11.17.
//  Copyright © 2017 e.a.morozova. All rights reserved.
//

import Foundation
import UIKit

protocol PicturesViewControllerDelegate {
    func updateProfileImage(image: UIImage)
}

class PicturesViewController: UICollectionViewController {
    
    let cellInRow = 3
    var imageUrls: [String] = []
    var model: PicturesViewModel?
    var delegate: PicturesViewControllerDelegate?
    var emitterAnimator: EmitterAnimator?
    
    override func viewDidLoad() {
        self.collectionView?.backgroundColor = UIColor.darkGray
        self.emitterAnimator = EmitterAnimator(view: self.view)
        
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
    
    @IBAction func cancelSelectAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 150
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.collectionView?.dequeueReusableCell(withReuseIdentifier: "image_cell", for: indexPath) as! ImageCell
        
        if !cell.isLoaded {
            let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            activityView.center = cell.imageView.center
            activityView.hidesWhenStopped = true
            cell.contentView.addSubview(activityView)
            activityView.startAnimating()
            
            if self.imageUrls.count > 0 {
                DispatchQueue.global(qos: .userInitiated).async {
                    let url = URL(string: self.imageUrls[indexPath.row])
                    let data = try? Data(contentsOf: url!)
                    
                    DispatchQueue.main.async {
                        if let image = UIImage(data: data!)?.crop(rect: CGRect(x: 0, y: 0, width: cell.imageView.frame.width, height: cell.imageView.frame.height)) {
                            cell.image = image
                            activityView.stopAnimating()
                        }
                    }
                }
            }
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? ImageCell, let image = cell.image {
            self.dismiss(animated: true, completion: nil)
            delegate?.updateProfileImage(image: image)
        }
    }
}

class ImageCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    var isLoaded: Bool = false
    
    var image: UIImage? {
        get { return imageView.image }
        set {
            imageView.image = newValue
            isLoaded = true
        }
    }
}

extension PicturesViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (collectionView.frame.size.width - CGFloat(cellInRow) * CGFloat(10)) / CGFloat(cellInRow)
        return CGSize(width: cellWidth, height: cellWidth)
    }
}

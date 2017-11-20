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
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = self.collectionView?.dequeueReusableCell(withReuseIdentifier: "image_cell", for: indexPath)
        
        return cell
    }
}

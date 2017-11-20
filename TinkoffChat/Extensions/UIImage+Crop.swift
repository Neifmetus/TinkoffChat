//
//  UIImage+Crop.swift
//  TinkoffChat
//
//  Created by e.a.morozova on 20.11.17.
//  Copyright © 2017 e.a.morozova. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func crop(rect: CGRect) -> UIImage? {
        var scaledRect = rect
        scaledRect.origin.x *= scale
        scaledRect.origin.y *= scale
        scaledRect.size.width *= scale
        scaledRect.size.height *= scale
        
        guard let imageRef: CGImage = cgImage?.cropping(to: scaledRect) else {
            return nil
        }
        
        return UIImage(cgImage: imageRef, scale: scale, orientation: imageOrientation)
    }
}

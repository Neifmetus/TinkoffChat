//
//  EmitterAnimator.swift
//  TinkoffChat
//
//  Created by e.bateeva on 28.11.2017.
//  Copyright © 2017 e.a.morozova. All rights reserved.
//

import Foundation
import UIKit

class EmitterAnimator: NSObject {
    
    var view: UIView
    var particleEmitter = CAEmitterLayer()
    var longPressHandler: UILongPressGestureRecognizer = UILongPressGestureRecognizer()
    
    init(view: UIView) {
        self.view = view
        super.init()
        
        longPressHandler = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressHandler.minimumPressDuration = 0.5
        self.view.addGestureRecognizer(longPressHandler)
    }
    
    @objc private func handleLongPress(_ sender: UILongPressGestureRecognizer) {
        if longPressHandler.state == .began {
            createParticles(view: self.view)
        } else if longPressHandler.state == .ended {
            particleEmitter.removeFromSuperlayer()
        }
    }
    
    func createParticles(view: UIView) {
        particleEmitter.emitterPosition = longPressHandler.location(in: view)
        particleEmitter.emitterShape = kCAEmitterLayerCircle
        particleEmitter.emitterSize = CGSize(width: 50, height: 50)
        
        let red = makeEmitterCell(color: UIColor.red)
        let green = makeEmitterCell(color: UIColor.green)
        let blue = makeEmitterCell(color: UIColor.blue)
        
        particleEmitter.emitterCells = [red, green, blue]
        
        view.layer.addSublayer(particleEmitter)
    }
    
    func makeEmitterCell(color: UIColor) -> CAEmitterCell {
        let cell = CAEmitterCell()
        
        cell.birthRate = 3
        cell.lifetime = 7.0
        cell.lifetimeRange = 0
        cell.color = color.cgColor
        cell.velocity = 200
        cell.velocityRange = 50
        cell.emissionLongitude = CGFloat.pi
        cell.emissionRange = CGFloat.pi / 4
        cell.spin = 2
        cell.spinRange = 3
        cell.scaleRange = 0.5
        cell.scaleSpeed = -0.05
        
        cell.contents = UIImage(named: "tinkoff_logo")?.cgImage
        cell.contentsScale = 5
        
        return cell
    }
}

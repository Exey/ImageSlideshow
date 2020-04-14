//
//  UIView.swift
//  
//
//  Created by exey on 29.11.2019.
//  Copyright © 2019 Exey Panteleev. All rights reserved.
//

import UIKit

class PassthroughView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        return view == self ? nil : view
    }
}

extension UIView {
    func layerGradient() {
        self.layer.sublayers?.forEach { $0.removeFromSuperlayer() }

        let layer: CAGradientLayer = CAGradientLayer()
        layer.frame.origin = CGPoint(x: 0.0, y: 0.0)
        let color0 = UIColor(red: 0, green: 0, blue: 0, alpha: 0.0).cgColor
        let color1 = UIColor(red: 0, green: 0, blue: 0, alpha: 0.8).cgColor
        layer.colors = [color0, color1]
        layer.locations = [0.55, 1.0]

        layer.frame.size = frame.size

        self.layer.insertSublayer(layer, at: 0)
    }
}

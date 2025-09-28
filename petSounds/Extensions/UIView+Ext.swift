//
//  UIView+Ext.swift
//  petSounds
//
//  Created by Müge Deniz on 3.02.2025.
//

import Foundation
import UIKit

extension UIView {
    func setCornerRadius(radius: CGFloat? = nil) {
        layer.masksToBounds = true
        if let radius = radius {
            layer.cornerRadius = radius
        } else {
            layer.cornerRadius = self.frame.height / 2
        }
    }
}

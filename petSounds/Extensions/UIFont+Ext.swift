//
//  UIFont+Ext.swift
//  petSounds
//
//  Created by Müge Deniz on 3.02.2025.
//

import Foundation
import UIKit

extension UIFont {
    static func balooRegular(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Baloo-Regular", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func balooMedium(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Baloo2-Medium", size: size) ?? UIFont.systemFont(ofSize: size, weight: .medium)
    }
    
    static func balooBold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Baloo2-Bold", size: size) ?? UIFont.systemFont(ofSize: size, weight: .bold)
    }
    static func baloo2Regular(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "Baloo2-Regular", size: size) ?? UIFont.systemFont(ofSize: size, weight: .regular)
    }
}



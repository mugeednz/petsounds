//
//  UI+Color.swift
//  petSounds
//
//  Created by Müge Deniz on 3.02.2025.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

extension UIColor {
    static let green = "B9FFCB".hexCode
    static let strokeColor = "CB5501".hexCode 
    static let translationStrokeColor = "932688".hexCode
    static let weekLabelColor = "AC03EA".hexCode
    static let monthLabelColor = "FDA519".hexCode
    static let yearLabelColor = "3967D6".hexCode

}

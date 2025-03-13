//
//  UIViewExtension.swift
//  StartTrack
//
//  Created by Hartzed Story on 13/3/25.
//

import UIKit

extension UIColor {
    convenience init?(hexString: String) {
        // Remove the "#" if it exists
        var hexSanitized = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hexSanitized.hasPrefix("#") {
            hexSanitized.remove(at: hexSanitized.startIndex)
        }

        // Ensure the string has a valid length (6 for RGB, 8 for RGBA)
        guard hexSanitized.count == 6 || hexSanitized.count == 8 else {
            return nil
        }

        // Get the values of the RGB components
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        if hexSanitized.count == 6 {
            self.init(
                red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgb & 0x0000FF) / 255.0,
                alpha: 1.0
            )
        } else if hexSanitized.count == 8 {
            // If the hex string includes an alpha component
            self.init(
                red: CGFloat((rgb & 0xFF000000) >> 24) / 255.0,
                green: CGFloat((rgb & 0x00FF0000) >> 16) / 255.0,
                blue: CGFloat((rgb & 0x0000FF00) >> 8) / 255.0,
                alpha: CGFloat(rgb & 0x000000FF) / 255.0
            )
        } else {
            return nil
        }
    }
}


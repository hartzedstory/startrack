//
//  Constants.swift
// CustomTabBar
//

//

import UIKit.UIFont

typealias CSp = Constants.Spacing

enum Constants {
    
    static let baseDeviceSize = CGSize(width: 390, height: 844)
    
    enum Spacing {
        static let min: CGFloat = 4
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 32
        static let xlarge: CGFloat = 64
        
        static func multiply4(by value: Int) -> CGFloat {
            return 4 * CGFloat(value)
        }
    }
}

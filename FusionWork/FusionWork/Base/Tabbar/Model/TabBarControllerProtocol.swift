//
//  TabBarControllerProtocol.swift
// CustomTabBar
//

//

import UIKit

protocol TabBarControllerProtocol: UITabBarController {
    func didTapTabBarButton(_ index: Int)
}

extension TabBarControllerProtocol {
    func didTapTabBarButton(_ index: Int) {
        selectedIndex = index
    }
}

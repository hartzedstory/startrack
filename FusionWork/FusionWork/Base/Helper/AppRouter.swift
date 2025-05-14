//
//  AppRouter.swift
//  FusionWork
//
//  Created by HartzedStory on 5/11/25.
//

import Foundation
import UIKit

class AppRouter {
    static var navigationController: UINavigationController?
    
    static func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

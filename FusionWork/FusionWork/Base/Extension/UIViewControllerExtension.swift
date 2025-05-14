//
//  UIViewControllerExtension.swift
//  FusionWork
//
//  Created by HartzedStory on 5/11/25.
//

import Foundation
import UIKit
extension UIViewController {
    func pushMeTo(_ viewController: UIViewController, animated: Bool = true) {
        viewController.hidesBottomBarWhenPushed = true
        viewController.hideKeyboardWhenTappedAround()
        self.navigationController?.pushViewController(viewController, animated: animated)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showAlert(title: String = "Notification", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { action in
            switch action.style{
                case .default:
                print("default")
                
                case .cancel:
                print("cancel")
                
                case .destructive:
                print("destructive")
                
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

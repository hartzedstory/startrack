//
//  ViewController.swift
//  StartTrack
//
//  Created by Hartzed Story on 12/3/25.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func loginOnTap(_ sender: Any) {
        //OAuth2 login
        
        setupTabbar()
        
    }
    
    private func setupTabbar() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.window?.rootViewController = MainTabBarController()
        }
    }
}

//
//  ViewController.swift
//  StartTrack
//
//  Created by Hartzed Story on 12/3/25.
//

import UIKit
import SwiftJWT

class ViewController: UIViewController {
    let authManager = AuthManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func loginOnTap(_ sender: Any) {
        ///OAuth2 login
        FusionLoading.show()
        authManager.startLogin { [weak self] access_token in
            FusionLoading.hide()
            guard let self = self else { return }
            print("Authorization code: \(access_token)")
            GlobalData.sharedInstance.access_token = access_token
            if let userClaim = JWTWorker.pareAccessTokene(access_token, toModel: UserClaimModel.self) {
                GlobalData.sharedInstance.user = userClaim.accessUser ?? UserModel()
                self.setupTabbar()
            }
        } onError: { error in
            FusionLoading.hide()
        }
    }
    
    private func setupTabbar() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.window?.rootViewController = MainTabBarController()
        }
    }
}

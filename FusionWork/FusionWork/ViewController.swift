//
//  ViewController.swift
//  StartTrack
//
//  Created by Hartzed Story on 12/3/25.
//

import UIKit
import SwiftJWT

let hasLaunchedKey = "hasLaunchedBefore"
let hasLaunchedBefore = UserDefaults.standard.bool(forKey: hasLaunchedKey)

class ViewController: UIViewController {
    let authManager = AuthManager()

    
    @IBOutlet weak var lblTermAndCondition: UILabel!
    @IBOutlet weak var btnLoginWithMicrosoft: UIButton!
    @IBOutlet weak var btnLoginWithGoogle: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        btnLoginWithMicrosoft.layer.borderWidth = 1
        btnLoginWithMicrosoft.layer.borderColor = UIColor(hex: "#007AFF", alpha: 1).cgColor
        btnLoginWithMicrosoft.layer.cornerRadius = 30
        btnLoginWithMicrosoft.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let hasLaunched = UserDefaults.standard.bool(forKey: "hasLaunchedBefore")
        if !hasLaunched {
            // Đánh dấu là đã mở lần đầu
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
            UserDefaults.standard.synchronize()

            // Khởi tạo IntroViewController từ XIB
            let introVC = FusionWalkthroughViewController(nibName: "FusionWalkthroughViewController", bundle: Bundle.main)
            introVC.modalPresentationStyle = .fullScreen
            introVC.modalTransitionStyle = .crossDissolve
            present(introVC, animated: true, completion: nil)
        }
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
                FusionNetwork.setDeviceID(userID: GlobalData.sharedInstance.user.userId ?? 0, deviceID: FCMTokenManager.getToken() ?? "") { response in
                    print(response)
                } onError: { error in
                    print(error)
                }

                self.setupTabbar()
            }
        } onError: { error in
            FusionLoading.hide()
        }
    }
    
    private func setupTabbar() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            UIView.transition(with: appDelegate.window ?? UIWindow(),
                              duration: 0.5,
                              options: [.transitionFlipFromLeft, .preferredFramesPerSecond60],
                              animations: {
                appDelegate.window?.rootViewController = MainTabBarController()
            }, completion: {_ in 
                let queryModel = SortingModel()
                queryModel.page = 0
                queryModel.size = 50
                FusionNetwork.getNotification(isRead: false, query: "", pageable: queryModel) { list in
                    GlobalData.sharedInstance.notificationUnReadList = list.reversed()
                } onError: { error in
                    print("Error")
                }
                
                FusionNetwork.getNotification(isRead: true, query: "", pageable: queryModel) { list in
                    GlobalData.sharedInstance.notificationReadList = list.reversed()
                } onError: { error in
                    print("Error")
                }
            })
        }
    }
    @IBAction func openTermAndCondition(_ sender: Any) {
        let webview = FusionWebView(inputURL: "https://imagination.vn/en/legalInformation")
        webview.modalPresentationStyle = .formSheet
        self.present(webview, animated: true)
    }
}

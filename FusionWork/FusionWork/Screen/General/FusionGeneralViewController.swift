//
//  FusionGeneralViewController.swift
//  FusionWork
//
//  Created by Hartzed Story on 26/5/25.
//

import UIKit
import SDWebImage

class FusionGeneralViewController: UIViewController {

    @IBOutlet weak var lblAvatar: UIImageView!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var vIndicator: UIView!
    @IBOutlet var swipeToBack: UIScreenEdgePanGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        swipeToBack.addTarget(self, action: #selector(popViewController))
        configUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if GlobalData.sharedInstance.notificationUnReadList.count > 0 {
            self.vIndicator.isHidden = false
        } else {
            self.vIndicator.isHidden = true
        }
    }

    
    func configUI() {
        self.lblAvatar.sd_setImage(with: URL(string: GlobalData.sharedInstance.user.avatarUrl ?? ""))
        self.lblUserName.text = GlobalData.sharedInstance.user.name
        self.lblPhone.text = GlobalData.sharedInstance.user.phone
        self.lblEmail.text = GlobalData.sharedInstance.user.email
        
    }
        
    @objc func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func logout(_ sender: Any) {
        self.showAlert(title: "Logout", message: "Do you want to logout from your account?") {
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let loginVC = storyboard.instantiateInitialViewController()
            
            UIView.transition(with: appDelegate.window ?? UIWindow(),
                              duration: 0.5,
                              options: [.transitionFlipFromRight, .preferredFramesPerSecond60],
                              animations: {
                appDelegate.window?.rootViewController = loginVC
            }, completion: {_ in
                FusionNetwork.logout {
                } onError: {
                }
            })
        
        } onCancel: {
            //ignore
        }
    }
    
    @IBAction func openSupport(_ sender: Any) {
        let webview = FusionWebView(inputURL: "https://imagination.vn/en/legalInformation")
        webview.modalPresentationStyle = .formSheet
        self.present(webview, animated: true)
    }
    
    @IBAction func openGeneralInformation(_ sender: Any) {
        let webview = FusionWebView(inputURL: "https://imagination.vn/en/legalInformation")
        webview.modalPresentationStyle = .formSheet
        self.present(webview, animated: true)
    }
    
    @IBAction func openNotification(_ sender: Any) {
        let vc = FusionNotificationViewController()
        self.pushMeTo(vc, animated: true)
    }
}

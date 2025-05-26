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
        self.showAlert(title: "Logout", message: "Do you want to logout from your account?. You have to open Fusion Work again due to privacy reason") {
            FusionNetwork.logout {
                exit(0)
            } onError: {
                exit(0)
            }
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
        
    }
}

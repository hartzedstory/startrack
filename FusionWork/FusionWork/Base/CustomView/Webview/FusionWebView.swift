//
//  FusionWebView.swift
//  FusionWork
//
//  Created by Hartzed Story on 23/5/25.
//

import UIKit
import WebKit

class FusionWebView: UIViewController {
    internal init(inputURL: String? = nil) {
        super.init(nibName: "FusionWebView", bundle: Bundle.main)
        self.inputURL = inputURL
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    @IBOutlet weak var webView: WKWebView!
    var inputURL: String?
    
    override func viewWillAppear(_ animated: Bool) {
        webView.uiDelegate = self
        guard let url = URL(string: inputURL ?? "") else {
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
extension FusionWebView: WKUIDelegate {
    
}

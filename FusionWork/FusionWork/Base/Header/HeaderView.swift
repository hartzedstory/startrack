//
//  HeaderView.swift
//  FusionWork
//
//  Created by HartzedStory on 5/11/25.
//

import Foundation
import UIKit

class HeaderView: UIView {
    
    @IBOutlet private var title: UILabel!
    @IBOutlet private var ivRight: UIImageView!
    @IBOutlet private var ivLeft: UIImageView!
    @IBOutlet private weak var vRight: UIView!
    
    var onHandleLeft: (() -> Void)?
    var onHandleRight: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.commonInit()

    }
    
    func setTitle(title: String) {
        self.title.text = title
    }
    
    func commonInit() {
        let nib = UINib(nibName: "HeaderView", bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }
    
    func hideRightImage() {
        self.ivRight.isHidden = true
        self.vRight.isHidden = true
    }
    
    @IBAction func onPressLeft(_ sender: Any) {
        if let leftAction = onHandleLeft {
            leftAction()
        } else {
            AppRouter.popViewController()
        }
        
    }
    @IBAction func onPressRight(_ sender: Any) {
        if let rightAction = onHandleRight {
            rightAction()
        }
    }
}

//
//  TagView.swift
//  StartTrack
//
//  Created by Hartzed Story on 13/3/25.
//

import Foundation
import UIKit

class TagView: UIView {
    
    @IBOutlet private weak var vMain: UIView!
    @IBOutlet private weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configLayout()
    }
    
    public func setTitle(value: String) {
        self.lblTitle.text = value
    }
    
    private func configLayout() {
        vMain.layer.cornerRadius = 9
        
    }
    
    override var intrinsicContentSize: CGSize {
        let labelSize = lblTitle.intrinsicContentSize
        self.setWidth(labelSize.width + 24)
        return CGSize(width: labelSize.width + 24, height: labelSize.height + 16)
    }
    
    private func setWidth(_ value: CGFloat) {
        self.vMain.widthAnchor.constraint(equalToConstant: value).isActive = true
        self.vMain.widthAnchor.constraint(equalToConstant: value).isActive = true
    }
}

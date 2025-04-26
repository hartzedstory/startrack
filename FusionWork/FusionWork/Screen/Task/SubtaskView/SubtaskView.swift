//
//  TagView.swift
//  StartTrack
//
//  Created by Hartzed Story on 13/3/25.
//

import Foundation
import UIKit

class SubtaskView: UIView {
    
    @IBOutlet weak var vMain: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var vPriority: UIView!
    
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
    
    
}

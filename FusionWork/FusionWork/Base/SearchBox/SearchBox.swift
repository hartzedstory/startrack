//
//  SearchBox.swift
//  FusionWork
//
//  Created by Hartzed Story on 26/5/25.
//

import Foundation
import UIKit

class SearchBox: UIView {
    
    @IBOutlet weak var vSearchContainer: UIView!
    @IBOutlet weak var vContainer: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.commonInit()
        
        self.vContainer.layer.cornerRadius = self.vContainer.frame.height / 2
        self.vSearchContainer.layer.cornerRadius = self.vSearchContainer.frame.height / 2
        self.vSearchContainer.layer.borderWidth = 1
        self.vSearchContainer.layer.borderColor = UIColor(hex: "#EDEDED").cgColor
    }
    
    func commonInit() {
        let nib = UINib(nibName: "SearchBox", bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 42
        )
    }
}

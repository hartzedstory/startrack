//
//  DescriptionView.swift
//  FusionWork
//
//  Created by HartzedStory on 5/12/25.
//

import Foundation
import UIKit
protocol DescriptionViewDelegate: AnyObject {
    func value(text: String)
}
class DescriptionView: UIView {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    var descriptionText = ""
    var delegate: DescriptionViewDelegate?
    
    init(_ title: String, delegate: UIViewController) {
        super.init(frame: .zero)
        commonInit()
        self.delegate = delegate as? any DescriptionViewDelegate
        configure(title: title)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 120)
    }
    
    private func configure(title: String) {
        lblTitle.text = title
        
    }
    
    func commonInit() {
        let nib = UINib(nibName: "DescriptionView", bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }
    
    @IBAction func onChangeValue(_ sender: Any) {
        self.descriptionText = textField.text ?? ""
        self.delegate?.value(text: self.descriptionText)
    }
}

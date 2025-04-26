//
//  FusionInputView.swift
//  StartTrack
//
//  Created by HartzedStory on 3/16/25.
//

import UIKit

class FusionInputView: UIView {
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var vTextField: UIView!
    @IBOutlet var ivRightImage: UIImageView!
    @IBOutlet var textField: UITextField!
    var onRightTap: (() -> Void)?
    

    init(_ title: String, _ image: UIImage?) {
        super.init(frame: .zero)
        commonInit()
        configure(title: title, image: image)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func configure(title: String, image: UIImage?) {
        lblTitle.text = title
        ivRightImage.image = image
        vTextField.layer.cornerRadius = 18
    }
    
    func commonInit() {
        let nib = UINib(nibName: "FusionInputView", bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 72)
    }
    
    func configUI() {
        if let action = onRightTap {
            action()
        }
    }
}

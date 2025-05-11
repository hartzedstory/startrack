//
//  FusionInputView.swift
//  StartTrack
//
//  Created by HartzedStory on 3/16/25.
//

import UIKit
protocol FusionInputTextDelegate: AnyObject {
    func inputValue(type: AddInputFieldType, value: String)
}
class FusionInputView: UIView {
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var vTextField: UIView!
    @IBOutlet var ivRightImage: UIImageView!
    @IBOutlet var textField: UITextField!
    
    var inputType: AddInputFieldType?
    var onRightTap: (() -> Void)?
    var delegate: FusionInputTextDelegate?

    init(_ title: AddInputFieldType, _ image: UIImage?, delegate: UIViewController) {
        super.init(frame: .zero)
        commonInit()
        configure(title: title.rawValue, image: image, delegate: delegate)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func configure(title: String, image: UIImage?, delegate: UIViewController) {
        lblTitle.text = title
        ivRightImage.image = image
        vTextField.layer.cornerRadius = 18
        self.delegate = delegate as? any FusionInputTextDelegate
        self.inputType = AddInputFieldType(rawValue: title)
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
    @IBAction func onChangeValue(_ sender: Any) {
        self.delegate?.inputValue(type: self.inputType ?? .none, value: self.textField.text ?? "")
    }
}

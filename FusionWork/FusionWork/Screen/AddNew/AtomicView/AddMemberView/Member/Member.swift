//
//  Member.swift
//  StartTrack
//
//  Created by HartzedStory on 3/17/25.
//

import UIKit
class Member: UIView {
    
    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var lblName: UILabel!
    var onRightTap: (()->Void)?
    init(_ name: String) {
        super.init(frame: .zero)
        commonInit()
        configure(name: name)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func configure(name: String) {
        lblName.text = name
        vContainer.layer.cornerRadius = 10
    }
    
    func commonInit() {
        let nib = UINib(nibName: "Member", bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 20)
    }
    
    func configUI() {
        if let action = onRightTap {
            action()
        }
    }
}

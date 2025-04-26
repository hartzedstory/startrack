//
//  AddMemberView.swift
//  StartTrack
//
//  Created by HartzedStory on 3/17/25.
//

import UIKit

class AddMemberView: UIView {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var vTextField: UIView!
    @IBOutlet weak var vTextbox: UIView!
    @IBOutlet weak var vMember: UIView!
    @IBOutlet weak var textField: UITextField!
    
    var onRightTap: (() -> Void)?
    

    init(_ title: String) {
        super.init(frame: .zero)
        commonInit()
        configure(title: title)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func configure(title: String) {
        lblTitle.text = title
        vTextField.layer.cornerRadius = 18
        vTextbox.layer.cornerRadius = 12.5
        vTextbox.layer.cornerRadius = 12.5
        configUI()
    }
    
    func commonInit() {
        let nib = UINib(nibName: "AddMemberView", bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 150)
    }
    
    func configUI() {
        if let action = onRightTap {
            action()
        }
        var x = 0
        var y = 0
        
        let view = Member("Nguyễn Anh Đức")
        view.frame.origin = CGPoint(x: 11, y: 0)
        let view2 = Member("Đoàn Ngọc Bích")
        view2.frame.origin = CGPoint(x: view.frame.width + 5, y: 0)
        let view3 = Member("Nguyễn Tiến Thuật")
        view3.frame.origin = CGPoint(x: view2.frame.width + 5, y: 0)
        let view4 = Member("Vũ Cao Trọng Nhân")
        view4.frame.origin = CGPoint(x: view3.frame.width + 5, y: 0)
        
        vMember.addSubview(view)
        vMember.addSubview(view2)
        vMember.addSubview(view3)
        vMember.addSubview(view4)
    }
}


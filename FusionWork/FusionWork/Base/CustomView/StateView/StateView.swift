//
//  StateView.swift
//  FusionWork
//
//  Created by HartzedStory on 5/12/25.
//

import Foundation
import UIKit
protocol StateDelegate: AnyObject {
    func value(state: State)
}
enum State: String, CaseIterable {
    case high = "HIGH"
    case medium = "MEDIUM"
    case low = "LOW"
    case none = ""
}
class StateView: UIView {
    
    @IBOutlet weak var lblEmergency: UILabel!
    @IBOutlet weak var lblMedium: UILabel!
    @IBOutlet weak var lblLow: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var vEmergency: UIView!
    @IBOutlet weak var vMedium: UIView!
    @IBOutlet weak var vLow: UIView!
    
    var state: State = .none
    var delegate: StateDelegate?
    init(_ title: String, delegate: UIViewController) {
        super.init(frame: .zero)
        commonInit()
        self.delegate = delegate as? any StateDelegate
        configure(title: title)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 60)
    }
    
    private func configure(title: String) {
        lblTitle.text = title
        vEmergency.layer.borderWidth = 1
        vEmergency.layer.borderColor = UIColor(hex: "#DD4A01", alpha: 1).cgColor
        
        vMedium.layer.borderWidth = 1
        vMedium.layer.borderColor = UIColor(hex: "#FFBB00", alpha: 1).cgColor
        
        vLow.layer.borderWidth = 1
        vLow.layer.borderColor = UIColor(hex: "#03DA5D", alpha: 1).cgColor
    }
    
    func commonInit() {
        let nib = UINib(nibName: "StateView", bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }
    
    func highlightView(state: State) {
        switch state {
        case .high:
            vEmergency.backgroundColor = UIColor(hex: "#DD4A01", alpha: 1)
            vMedium.backgroundColor = .white
            vLow.backgroundColor = .white
            
            lblEmergency.textColor = .white
            lblMedium.textColor = .black
            lblLow.textColor = .black
        case .medium:
            vEmergency.backgroundColor = .white
            vMedium.backgroundColor = UIColor(hex: "#FFBB00", alpha: 1)
            vLow.backgroundColor = .white
            
            lblEmergency.textColor = .black
            lblMedium.textColor = .white
            lblLow.textColor = .black
        case .low:
            vEmergency.backgroundColor = .white
            vMedium.backgroundColor = .white
            vLow.backgroundColor = UIColor(hex: "#03DA5D", alpha: 1)
            
            lblEmergency.textColor = .black
            lblMedium.textColor = .black
            lblLow.textColor = .white
        case .none:
            vEmergency.backgroundColor = .white
            vMedium.backgroundColor = .white
            vLow.backgroundColor = .white
        }
        
        self.delegate?.value(state: self.state)
    }
    
    
    @IBAction func emergeOnTap(_ sender: Any) {
        self.state = .high
        self.highlightView(state: self.state)
    }
    
    @IBAction func mediumOnTap(_ sender: Any) {
        self.state = .medium
        self.highlightView(state: self.state)
    }
    
    @IBAction func lowOnTap(_ sender: Any) {
        self.state = .low
        self.highlightView(state: self.state)
    }
}


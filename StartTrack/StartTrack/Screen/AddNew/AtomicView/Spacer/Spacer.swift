//
//  Spacer.swift
//  StartTrack
//
//  Created by HartzedStory on 3/16/25.
//

import UIKit

class Spacer: UIView {
    private var heightConstraint: NSLayoutConstraint?
    
    init(height: CGFloat = 0) {
        super.init(frame: .zero)
        setupView(height: height)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView(height: 0)
    }
    
    private func setupView(height: CGFloat) {
        self.backgroundColor = .clear
        self.translatesAutoresizingMaskIntoConstraints = false
        heightConstraint = self.heightAnchor.constraint(equalToConstant: height)
        heightConstraint?.isActive = true
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: heightConstraint?.constant ?? 0)
    }
}



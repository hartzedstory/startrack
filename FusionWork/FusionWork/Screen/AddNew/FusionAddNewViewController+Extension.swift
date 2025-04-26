//
//  FusionAddNewViewController+Extension.swift
//  StartTrack
//
//  Created by HartzedStory on 3/16/25.
//

import Foundation
import UIKit

extension FusionAddNewViewController {
    func layoutStackView(arrView: [UIView]) {
        arrView.forEach { view in
            self.stackView.addArrangedSubview(view)
        }
        calculateHeight()
    }
    
    private func calculateHeight() {
        var totalHeight = 0
        for view in stackView.arrangedSubviews {
            totalHeight += Int(view.intrinsicContentSize.height)
        }
        
        self.heightContainer.constant = CGFloat(totalHeight)
//        self.heightContainer.isActive = true
    }
}

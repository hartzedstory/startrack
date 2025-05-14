//
//  ProgressView.swift
//  FusionWork
//
//  Created by HartzedStory on 5/11/25.
//

import Foundation
import UIKit

import UIKit

class ProgressView: UIView {
    
    private let titleLabel = UILabel()
    private let percentLabel = UILabel()
    private let backgroundLayer = CAShapeLayer()
    private let progressLayer = CAShapeLayer()
    private let pathInset: CGFloat = 20

    private var displayLink: CADisplayLink?
    private var animationStartTime: CFTimeInterval = 0
    private var animationDuration: TimeInterval = 1.0
    private var targetValue: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }

    private func setupLayers() {
        backgroundColor = .clear

        // Path: bán tròn (từ trái sang phải, phía trên)
        let radius = (min(bounds.width, bounds.height) - pathInset * 2) / 2
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let startAngle = 2 * CGFloat.pi / 3
        let endAngle = (CGFloat.pi / 3) + 2 * CGFloat.pi

        let path = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true
        )

        // Track layer (nền mờ)
        backgroundLayer.path = path.cgPath
        backgroundLayer.strokeColor = UIColor(hex: "#007AFF", alpha: 0.3).cgColor
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.lineWidth = 20
        backgroundLayer.lineCap = .round
        layer.addSublayer(backgroundLayer)

        // Progress layer
        progressLayer.path = path.cgPath
        progressLayer.strokeColor = UIColor(hex: "#007AFF", alpha: 1.0).cgColor
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = 20
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = 0
        layer.addSublayer(progressLayer)
        
        titleLabel.text = "Hoàn thành"
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        titleLabel.textColor = UIColor(hex: "#615E83", alpha: 1.0)
        titleLabel.textAlignment = .center
        addSubview(titleLabel)

        // Percent label
        percentLabel.text = "0%"
        percentLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        percentLabel.textColor = UIColor(hex: "#1E1B39", alpha: 1.0)
        percentLabel.textAlignment = .center
        addSubview(percentLabel)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundLayer.frame = bounds
        progressLayer.frame = bounds
        titleLabel.frame = CGRect(
            x: 0,
            y: bounds.midY - 25,
            width: bounds.width,
            height: 20
        )

        percentLabel.frame = CGRect(
            x: 0,
            y: bounds.midY,
            width: bounds.width,
            height: 30
        )
    }

    /// Animate progress: value 0.0 ~ 1.0
    func setProgress(to value: CGFloat, duration: TimeInterval = 1.0) {
        let clamped = max(0, min(1,value))
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = clamped
        animation.duration = duration
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        progressLayer.add(animation, forKey: "progressAnim")
        self.targetValue = clamped
        startAnimatingPercent()
    }
    
    private func startAnimatingPercent() {
        displayLink?.invalidate()
        animationStartTime = CACurrentMediaTime()
        displayLink = CADisplayLink(target: self, selector: #selector(updatePercentLabel))
        displayLink?.add(to: .main, forMode: .default)
    }

    @objc private func updatePercentLabel() {
        let elapsed = CACurrentMediaTime() - animationStartTime
        let progress = min(1.0, elapsed / animationDuration)
        let currentValue = Int(round(progress * targetValue * 100))
        percentLabel.text = "\(currentValue)%"

        if progress >= 1.0 {
            displayLink?.invalidate()
            displayLink = nil
        }
    }

}


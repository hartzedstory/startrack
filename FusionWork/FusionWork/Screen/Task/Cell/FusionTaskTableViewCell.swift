//
//  FusionTaskTableViewCell.swift
//  StartTrack
//
//  Created by Hartzed Story on 13/3/25.
//

import UIKit

class FusionTaskTableViewCell: UITableViewCell {

    @IBOutlet weak var ivState: UIImageView!
    @IBOutlet weak var vSecondLayer: UIView!
    @IBOutlet weak var vFirstLayer: UIView!
    @IBOutlet weak var vMain: UIView!
    @IBOutlet weak var subTaskStackView: UIStackView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var vSubTask: UIView!
    @IBOutlet weak var vPriority: UIView!
    
    
    private var isDone = false
    var isHasSubTask = false
    var isCollapsed = false
    var closure: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    
    private func setupUI() {
        if let demoView = Bundle.main.loadNibNamed("TagView", owner: self)?.first as? TagView  {
            let widthConstraint = demoView.widthAnchor.constraint(equalToConstant: 39)
            widthConstraint.isActive = true  // Activate the constraint
            stackView.addArrangedSubview(demoView)
        }
        if let demoView = Bundle.main.loadNibNamed("TagView", owner: self)?.first as? TagView  {
            let widthConstraint = demoView.widthAnchor.constraint(equalToConstant: 39)
            widthConstraint.isActive = true  // Activate the constraint
            stackView.addArrangedSubview(demoView)
        }
        
        
        
        vFirstLayer.layer.cornerRadius = 20
        vSecondLayer.layer.cornerRadius = 20
        vMain.layer.cornerRadius = 20
        vSubTask.layer.cornerRadius = 20
        vPriority.layer.cornerRadius = vPriority.frame.width / 2
        

    }

    @IBAction func actionOnTap(_ sender: Any) {
        if isHasSubTask {
            if isCollapsed {
                self.vSubTask.isHidden = true
                self.vFirstLayer.backgroundColor = UIColor(hexString: "#E2F2FF")
                self.vSecondLayer.backgroundColor = UIColor(hexString: "#D3E8FF")
                subTaskStackView.arrangedSubviews.forEach { subview in
                    stackView.removeArrangedSubview(subview)
                    subview.removeFromSuperview()
                }
            } else {
                self.vSubTask.isHidden = false
                if let subtask = Bundle.main.loadNibNamed("SubtaskView", owner: self)?.first as? SubtaskView {
                    let widthConstraint = subtask.heightAnchor.constraint(equalToConstant: 56)
                    widthConstraint.isActive = true  // Activate the constraint
                    subTaskStackView.addArrangedSubview(subtask)
                }
                if let subtask = Bundle.main.loadNibNamed("SubtaskView", owner: self)?.first as? SubtaskView {
                    let widthConstraint = subtask.heightAnchor.constraint(equalToConstant: 56)
                    widthConstraint.isActive = true  // Activate the constraint
                    subTaskStackView.addArrangedSubview(subtask)
                }
                self.vFirstLayer.backgroundColor = .white
                self.vSecondLayer.backgroundColor = .white
            }
            if let action = closure {
                action()
            }
        }
    }
    
    @IBAction func changeStateOnTap(_ sender: Any) {
        self.isDone = !self.isDone
        ivState.isHighlighted = isDone
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

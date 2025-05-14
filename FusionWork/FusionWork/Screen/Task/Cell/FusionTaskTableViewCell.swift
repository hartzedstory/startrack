//
//  FusionTaskTableViewCell.swift
//  StartTrack
//
//  Created by Hartzed Story on 13/3/25.
//

import UIKit

class FusionTaskTableViewCell: UITableViewCell {

    @IBOutlet weak var lblHour: UILabel!
    @IBOutlet weak var lblPeriod: UILabel!
    @IBOutlet weak var lblTimeline: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var ivState: UIImageView!
    @IBOutlet weak var vSecondLayer: UIView!
    @IBOutlet weak var vFirstLayer: UIView!
    @IBOutlet weak var vMain: UIView!
    @IBOutlet weak var subTaskStackView: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var vSubTask: UIView!
    @IBOutlet weak var vPriority: UIView!
    
    
    private var isDone = false
    var model: ProjectModel?
    var isHasSubTask = false
    var isCollapsed = false
    var closure: (() -> Void)?
    var tapDone: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    
    private func setupUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "TagView", bundle: Bundle.main), forCellWithReuseIdentifier: "cell")
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            layout.itemSize = UICollectionViewFlowLayout.automaticSize
        }
        
        if self.isHasSubTask {
            
        } else {
            self.vSubTask.isHidden = true
            self.vFirstLayer.isHidden = true
            self.vSecondLayer.isHidden = true
        }
        vFirstLayer.layer.cornerRadius = 20
        vSecondLayer.layer.cornerRadius = 20
        vMain.layer.cornerRadius = 20
        vSubTask.layer.cornerRadius = 20
        vPriority.layer.cornerRadius = vPriority.frame.width / 2
    }
    
    func bindingData(model: ProjectModel) {
        self.lblTitle.text = model.name
        self.model = model
        
        let isoFormatter = DateFormatter()
        isoFormatter.locale = Locale(identifier: "en_US_POSIX")
        isoFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let date = isoFormatter.date(from: model.endDate ?? "") {

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            let formattedDate = dateFormatter.string(from: date)

            // Bước 3: Lấy giờ (HH:mm:ss)
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "hh:mm a"
            let formattedTime = timeFormatter.string(from: date)

            let components = formattedTime.components(separatedBy: " ")
            let formattedTime12h = components.first ?? ""
            let period = components.last ?? ""
            
            self.lblTimeline.text = formattedDate
            self.lblHour.text = formattedTime12h
            self.lblPeriod.text = period
        }
        
        let priority = State(rawValue: model.priority ?? "")
        switch priority {
        case .high:
            self.vPriority.backgroundColor = UIColor(hex: "#DD4A01", alpha: 1)
        case .medium:
            self.vPriority.backgroundColor = UIColor(hex: "#FFBB00", alpha: 1)
        case .low:
            self.vPriority.backgroundColor = UIColor(hex: "#03DA5D", alpha: 1)
        case .none, .some(.none):
            break
        }
    }

    @IBAction func actionOnTap(_ sender: Any) {
        if isHasSubTask {
            if isCollapsed {
                self.vSubTask.isHidden = true
                self.vFirstLayer.backgroundColor = UIColor(hexString: "#E2F2FF")
                self.vSecondLayer.backgroundColor = UIColor(hexString: "#D3E8FF")
                subTaskStackView.arrangedSubviews.forEach { subview in
                    collectionView.isHidden = true
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
        if let action = self.tapDone {
            action()
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension FusionTaskTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TagView
        cell.lblTitle.text = model?.organization
        return cell
    }
    
    
}

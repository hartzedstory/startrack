//
//  FusionTaskTableViewCell.swift
//  StartTrack
//
//  Created by Hartzed Story on 13/3/25.
//

import UIKit
enum ShowTaskForView {
    case project
    case task
}
class FusionTaskTableViewCell: UITableViewCell {

    @IBOutlet weak var lblHour: UILabel!
    @IBOutlet weak var lblPeriod: UILabel!
    @IBOutlet weak var lblTimeline: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var ivState: UIImageView!
    @IBOutlet weak var vSecondLayer: UIView!
    @IBOutlet weak var vFirstLayer: UIView!
    @IBOutlet weak var vMain: UIView!
    @IBOutlet weak var subtaskTableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var vSubTask: UIView!
    @IBOutlet weak var vPriority: UIView!
    
    
    private var isDone = false
    var model: ProjectModel?
    var taskModel: TaskModel?
    var isHasSubTask = false
    var isCollapsed = false
    var showType: ShowTaskForView = .task
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
        subtaskTableView.delegate = self
        subtaskTableView.dataSource = self
        subtaskTableView.register(UINib(nibName: "SubtaskCell", bundle: Bundle.main), forCellReuseIdentifier: "subCell")
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            layout.itemSize = UICollectionViewFlowLayout.automaticSize
        }
        
        vFirstLayer.layer.cornerRadius = 20
        vSecondLayer.layer.cornerRadius = 20
        vMain.layer.cornerRadius = 20
        vSubTask.layer.cornerRadius = 20
        vPriority.layer.cornerRadius = vPriority.frame.width / 2
    }
    
    func bindingData(model: ProjectModel) {
        self.showType = .project
        self.lblTitle.text = model.name
        self.model = model
        if model.taskInfos?.count ?? 0 > 0 {
            self.vSubTask.isHidden = false
            self.vFirstLayer.isHidden = false
            self.vSecondLayer.isHidden = false
            self.isHasSubTask = true
        } else {
            self.vSubTask.isHidden = true
            self.vFirstLayer.isHidden = true
            self.vSecondLayer.isHidden = true
            self.isHasSubTask = false
        }
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
    func bindingData(model: TaskModel) {
        self.showType = .task
        self.lblTitle.text = model.taskName
        self.taskModel = model
        if model.subtaskList?.count ?? 0 > 0 {
            self.vSubTask.isHidden = false
            self.vFirstLayer.isHidden = false
            self.vSecondLayer.isHidden = false
            self.isHasSubTask = true
        } else {
            self.vSubTask.isHidden = true
            self.vFirstLayer.isHidden = true
            self.vSecondLayer.isHidden = true
            self.isHasSubTask = false
        }
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
                self.subtaskTableView.isHidden = true
            } else {
                self.vSubTask.isHidden = false
                self.subtaskTableView.isHidden = false
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
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TagView
        cell.lblTitle.text = model?.organization
        return cell
    }
}


extension FusionTaskTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.showType {
        case .project:
            return self.model?.taskInfos?.count ?? 0
        case .task:
            return self.taskModel?.subtaskList?.count ?? 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subCell", for: indexPath) as! SubtaskCell
        switch self.showType {
        case .project:
            cell.bindingData(task: self.model?.taskInfos?[indexPath.row] ?? ProjectTaskInfoModel())
        case .task:
            cell.bindingData(task: self.taskModel?.subtaskList?[indexPath.row] ?? TaskModel())
        }

        return cell
    }
    
    
}

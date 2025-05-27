//
//  FusionTaskViewController.swift
//  StartTrack
//
//  Created by HartzedStory on 3/12/25.
//

import UIKit

class FusionTaskViewController: UIViewController {

    @IBOutlet weak var ivEmpty: UIImageView!
    @IBOutlet weak var vIndicator: UIView!
    @IBOutlet weak var lblNoti: UILabel!
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var tableView: UITableView!
    var indexPathRowExpanded: Set<IndexPath> = []
    var viewModel = FusionTaskViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        let queryModel = SortingModel()
        queryModel.page = 0
        queryModel.size = 50
        viewModel.getTask(sorting: queryModel, start: getCurrentUTCDateString(), end: getCurrentUTCDateString()) {
            
            if self.viewModel.listTask.count == 0 {
                self.lblNoti.isHidden = false
                self.ivEmpty.isHidden = false
                self.tableView.isHidden = true
                self.lblNoti.text = "Good time to take a break~"
            } else {
                self.lblNoti.isHidden = true
                self.ivEmpty.isHidden = true
                self.tableView.isHidden = false
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if GlobalData.sharedInstance.notificationUnReadList.count > 0 {
            self.vIndicator.isHidden = false
        } else {
            self.vIndicator.isHidden = true
        }
    }
    
    func getCurrentUTCDateString() -> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: date)
    }
    
    private func setupUI() {
        hideKeyboardWhenTappedAround()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FusionTaskTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "cell")
        configUIDatePicker()
    }
    
    private func configUIDatePicker() {
        let datePicker = UIDatePicker()
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .inline
        }
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        
        let container = UIView(frame: .init(x: 0, y: 0, width: 0, height: 0))
        container.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            datePicker.bottomAnchor.constraint(equalTo: container.safeAreaLayoutGuide.bottomAnchor),
            datePicker.topAnchor.constraint(equalTo: container.safeAreaLayoutGuide.topAnchor),
            datePicker.leadingAnchor.constraint(equalTo: container.safeAreaLayoutGuide.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: container.safeAreaLayoutGuide.trailingAnchor),
        ])
        textField.inputView = datePicker
    }
    
    @objc private func dateChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        textField.text = formatter.string(from: sender.date)
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd/MM/yyyy HH:mm" // format bạn đã dùng để hiển thị
        inputFormatter.timeZone = TimeZone.current
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        outputFormatter.timeZone = TimeZone(secondsFromGMT: 0) // quan trọng để ra "Z" (UTC)

        if let date = inputFormatter.date(from: textField.text ?? "") {

            let result = outputFormatter.string(from: date) ///--> Dùng để request
            let queryModel = SortingModel(page: 0, size: 50)
            viewModel.getTask(sorting: queryModel, start: result, end: result) {
                if self.viewModel.listTask.count == 0 {
                    self.lblNoti.isHidden = false
                    self.tableView.isHidden = true
                    self.lblNoti.text = "Good time to take a break~"
                    print("XXXXXXXXXXXX")
                } else {
                    self.lblNoti.isHidden = true
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                }
            }
        } else {
            print("⛔️ Không thể chuyển text sang ngày")
        }
        
        if let displayDate = inputFormatter.date(from: textField.text ?? "") {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "dd/MM/yyyy"
            outputFormatter.timeZone = TimeZone(secondsFromGMT: 0)

            let result = outputFormatter.string(from: displayDate)
            print(result)
            self.textField.text = compareToToday(date: displayDate)
        } else {
            print("⛔️ Không thể chuyển text sang ngày")
        }
    }
    
    
    func compareToToday(date: Date) -> String {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let inputDate = calendar.startOfDay(for: date)
        if inputDate == today {
            return "Today"
        } else if let tomorrow = calendar.date(byAdding: .day, value: 1, to: today),
                  inputDate == tomorrow {
            return "Tomorrow"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy"
            return formatter.string(from: date)
        }
    }
    @IBAction func showDatePicker(_ sender: Any) {
        self.textField.becomeFirstResponder()
    }
     
    @IBAction func openGeneralSetting(_ sender: Any) {
        let vc = FusionGeneralViewController()
        pushMeTo(vc, animated: true)
    }
    
    @IBAction func openNoti(_ sender: Any) {
        let vc = FusionNotificationViewController()
        self.pushMeTo(vc, animated: true)
    }
}
extension FusionTaskViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.listTask.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellHeightExpanded = 120 + 20 + (57 * (self.viewModel.listTask[indexPath.row].subtaskList?.count ?? 0))
        return CGFloat(indexPathRowExpanded.contains(indexPath) ? cellHeightExpanded : 120)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! FusionTaskTableViewCell
        cell.bindingData(model: self.viewModel.listTask[indexPath.row])
        cell.selectionStyle = .none
        cell.closure = { [weak self] in
            guard let self = self else { return }
            cell.isCollapsed = !cell.isCollapsed
            
            if self.indexPathRowExpanded.contains(indexPath) {
                self.indexPathRowExpanded.remove(indexPath) // Nếu đã mở thì thu gọn
            } else {
                self.indexPathRowExpanded.insert(indexPath) // Nếu đang thu gọn thì mở rộng
            }
            UIView.animate(withDuration: 0.3) {
                self.tableView.beginUpdates()
                self.tableView.endUpdates()
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _, completion in
            //Remove data array
            //Nếu task có subtask --> remove subtask trước rồi xóa task
            if self.viewModel.listTask[indexPath.row].subtaskList?.count ?? 0 > 0 {
                
                self.viewModel.listTask[indexPath.row].subtaskList?.forEach { subtask in
                    FusionNetwork.deleteSubtask(taskID: self.viewModel.listTask[indexPath.row].id ?? 0, subtaskID: subtask.id ?? 0) {
                        //
                    }
                }
                
                FusionNetwork.deleteTask(taskID: self.viewModel.listTask[indexPath.row].id ?? 0) {
                    //
                }
                
            } else {
                FusionNetwork.deleteTask(taskID: self.viewModel.listTask[indexPath.row].id ?? 0) {
                    //
                }
            }
            
            self.viewModel.listTask.remove(at: indexPath.row)
            //Delete row at tableview
            tableView.deleteRows(at: [indexPath], with: .automatic)

            completion(true)
        }
        deleteAction.image = UIImage(named: "ic_delete")
        deleteAction.backgroundColor = UIColor(hexString: "#F6F6F6")
        
        let config = UISwipeActionsConfiguration(actions: [deleteAction])
        return config
    }
    
}

//
//  FusionNotificationViewController.swift
//  FusionWork
//
//  Created by Hartzed Story on 27/5/25.
//

import UIKit

enum FusionNotificationType {
    case unread
    case read
}
class FusionNotificationViewController: UIViewController {

    @IBOutlet var widthConstraintSearchBox: NSLayoutConstraint!
    @IBOutlet weak var searchBox: SearchBox!
    @IBOutlet var constraintUnread: NSLayoutConstraint!
    @IBOutlet var constraintRead: NSLayoutConstraint!
    @IBOutlet weak var vSwitcherContainer: UIView!
    @IBOutlet weak var lblUnread: UILabel!
    @IBOutlet weak var lblRead: UILabel!
    @IBOutlet weak var vIndicator: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var swipeBack: UIScreenEdgePanGestureRecognizer!
    var type: FusionNotificationType = .unread
    var dataSource: [NotificationModel] = []
    var filteredDataSource: [NotificationModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.decideView(type: .unread)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FusionNotificationCell", bundle: Bundle.main), forCellReuseIdentifier: "cell")
        searchBox.delegate = self
        swipeBack.addTarget(self, action: #selector(popViewController))
    }
    
    @objc func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func decideView(type: FusionNotificationType) {
        self.type = type
        switch type {
        case .unread:
            UIView.animate(withDuration: 0.3) {
                self.constraintRead.isActive = false
                self.constraintUnread.isActive = true
                self.lblUnread.textColor = UIColor(hexString: "#007AFF")
                self.lblRead.textColor = UIColor(hexString: "#909090")
                self.vSwitcherContainer.layoutIfNeeded()
            }
            self.dataSource = GlobalData.sharedInstance.notificationUnReadList
            self.filteredDataSource = self.dataSource
            self.tableView.reloadData()
        case .read:
            UIView.animate(withDuration: 0.3) {            self.constraintRead.isActive = true
                self.constraintUnread.isActive = false
                self.lblRead.textColor = UIColor(hexString: "#007AFF")
                self.lblUnread.textColor = UIColor(hexString: "#909090")
                self.vSwitcherContainer.layoutIfNeeded()
            }
            self.dataSource = GlobalData.sharedInstance.notificationReadList
            self.filteredDataSource = self.dataSource
            self.tableView.reloadData()
        }
    }

    
    @IBAction func selectFirst(_ sender: Any) {
        decideView(type: .unread)
    }
    @IBAction func selectSecond(_ sender: Any) {
        decideView(type: .read)
    }
    
    @IBAction func openSearch(_ sender: Any) {
        UIView.animate(withDuration: 0.25) {
            self.widthConstraintSearchBox.constant = UIScreen.main.bounds.width - 18
            self.view.layoutIfNeeded()
        }
    }
    
}

extension FusionNotificationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredDataSource.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! FusionNotificationCell
        switch type {
        case .unread:
            cell.bindingData(model: filteredDataSource[indexPath.row], type: .unread)
            
        case .read:
            cell.bindingData(model: filteredDataSource[indexPath.row], type: .read)
        }
        
        cell.closure = { [weak self] in
            guard let self = self else { return }
            FusionNetwork.updateNotification(id: filteredDataSource[indexPath.row].id ?? 0) { model in
                print("Success")
                let queryModel = SortingModel()
                queryModel.page = 0
                queryModel.size = 50
                
                FusionNetwork.getNotification(isRead: false, query: "", pageable: queryModel) { list in
                    GlobalData.sharedInstance.notificationUnReadList = list
                    self.tableView.reloadData()
                } onError: { error in
                    print("Error")
                }
                
                FusionNetwork.getNotification(isRead: true, query: "", pageable: queryModel) { list in
                    GlobalData.sharedInstance.notificationReadList = list
                    self.tableView.reloadData()
                } onError: { error in
                    print("Error")
                }
            } onError: { error in
                print("Error")
            }
        }
        return cell
    }
}

extension FusionNotificationViewController: SearchBoxDelegate {
    func onCancel() {
        UIView.animate(withDuration: 0.25) {
            self.widthConstraintSearchBox.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func onSearch(keyword: String) {
        if keyword == "" {
            switch type {
            case .unread:
                self.filteredDataSource = GlobalData.sharedInstance.notificationUnReadList
            case .read:
                self.filteredDataSource = GlobalData.sharedInstance.notificationReadList
            }
            
        } else {
            self.filteredDataSource = self.dataSource.filter { item in
                (item.subject ?? "").lowercased().contains(keyword.lowercased())
            }
        }
        self.tableView.reloadData()
    }
}

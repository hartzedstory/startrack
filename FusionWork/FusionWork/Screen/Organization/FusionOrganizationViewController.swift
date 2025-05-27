//
//  FusionOrganizationViewController.swift
//  FusionWork
//
//  Created by HartzedStory on 5/3/25.
//

import UIKit

class FusionOrganizationViewController: UIViewController {

    @IBOutlet var widthConstraintSearchBox: NSLayoutConstraint!
    @IBOutlet weak var vSearchBox: SearchBox!
    @IBOutlet weak var lblNoti: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel = FusionOrganizationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        
    }
    
    private func configUI() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "FusionOrganizationCell", bundle: Bundle.main), forCellReuseIdentifier: "cell")
        self.viewModel.getOrganization { [weak self] in
            guard let self = self else { return }
            if self.viewModel.organizations.count == 0 {
                self.lblNoti.isHidden = false
                self.tableView.isHidden = true
                self.lblNoti.text = "You have no organization currently. Create one by clicking on the button above."
            } else {
                self.lblNoti.isHidden = true
                self.tableView.reloadData()
            }
        }
        self.vSearchBox.delegate = self
    }

    @IBAction func addOnTap(_ sender: Any) {
        self.addNew(kind: .organization)
    }
    
    private func addNew(kind: AddNewType) {
        let vc = FusionAddNewViewController(kind)
        vc.modalPresentationStyle = .fullScreen
        vc.addCompletion = { [weak self] in
            guard let self = self else { return }
            self.viewModel.getOrganization {
                if self.viewModel.organizations.count == 0 {
                    self.lblNoti.isHidden = false
                    self.tableView.isHidden = true
                    self.lblNoti.text = "You have no organization currently. Create one by clicking on the button above."
                } else {
                    self.lblNoti.isHidden = true
                    self.tableView.reloadData()
                }
            }
        }
        self.present(vc, animated: true)
    }
    @IBAction func openSearchBox(_ sender: Any) {
        UIView.animate(withDuration: 0.25) {
            self.widthConstraintSearchBox.constant = UIScreen.main.bounds.width - 18
            self.view.layoutIfNeeded()
        }
    }
}

extension FusionOrganizationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.filteredOrganizations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FusionOrganizationCell
        cell.lblName.text = self.viewModel.filteredOrganizations[indexPath.row].name
        cell.closure = { [weak self] in
            guard let self = self else { return }
            self.viewModel.getOrganizationDetail(id: self.viewModel.filteredOrganizations[indexPath.row].id ?? 0)
            FusionNetwork.getOrganizationReport(id: self.viewModel.filteredOrganizations[indexPath.row].id ?? 0) { response in
                var donePercentage = 0
                if let total = response.monitor?.total {
                    if total == 0 {
                        
                    } else {
                        donePercentage = (response.monitor?.done ?? 0) / (response.monitor?.total ?? 0)
                    }
                }
                let vc = FusionOrganizationDetailViewController(donePercentage: donePercentage, done: response.monitor?.done ?? 0, notDone: response.monitor?.notDone ?? 0, total: response.monitor?.total ?? 0, orgName: self.viewModel.filteredOrganizations[indexPath.row].name ?? "")
                self.pushMeTo(vc, animated: true)
            } onError: { error in
                
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

extension FusionOrganizationViewController: SearchBoxDelegate {
    func onCancel() {
        UIView.animate(withDuration: 0.25) {
            self.widthConstraintSearchBox.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    func onSearch(keyword: String) {
        if keyword == "" {
            self.viewModel.filteredOrganizations = self.viewModel.organizations
        } else {
            self.viewModel.filteredOrganizations = self.viewModel.organizations.filter { item in
                (item.name ?? "").lowercased().contains(keyword.lowercased())
            }
        }
        self.tableView.reloadData()
    }
}

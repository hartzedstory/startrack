//
//  FusionProjectViewController.swift
//  StartTrack
//
//  Created by Hartzed Story on 13/3/25.
//

import UIKit

class FusionProjectViewController: UIViewController {
    @IBOutlet weak var ivEmpty: UIImageView!
    @IBOutlet weak var lblNoti: UILabel!
    @IBOutlet weak var lblOrgName: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnSelectOrg: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var vSearchBox: SearchBox!
    @IBOutlet var widthConstraintSearchBox: NSLayoutConstraint!
    var indexPathRowExpanded: Set<IndexPath> = []
    var viewModel = FusionProjectViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true
        tableView.register(UINib(nibName: "FusionTaskTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "cell")
        self.configAddDropDown()
        self.viewModel.getOrganization { [weak self] in
            guard let self = self else { return }
            self.lblOrgName.text = self.viewModel.organizations.first?.name ?? ""
            self.viewModel.selectedOrganization = self.viewModel.organizations.first
            self.configSelectOrgDropDown()
            self.viewModel.getListProject {
                if self.viewModel.selectedOrganization == nil {
                    self.lblNoti.isHidden = false
                    self.ivEmpty.isHidden = false
                    self.lblOrgName.text = "Empty"
                    self.lblNoti.text = "No organization\nCreate new organization\nto start using Fusion Work"
                    self.tableView.isHidden = true
                } else {
                    if self.viewModel.filteredProject.count == 0 {
                        self.lblNoti.isHidden = false
                        self.ivEmpty.isHidden = false
                        self.lblNoti.text = "No project\nStart your journey now!!!"
                        self.tableView.isHidden = true
                    } else {
                        self.lblNoti.isHidden = true
                        self.ivEmpty.isHidden = true
                        self.tableView.reloadData()
                        self.tableView.isHidden = false
                    }
                }
 
            }
        }
        hideKeyboardWhenTappedAround()
        self.vSearchBox.delegate = self

    }
    
    private func configAddDropDown() {
        let firstAction = UIAction(title: "New project", image: UIImage(systemName: "plus.circle.dashed")) { action in
            self.addNew(kind: .project)
        }
        let secondAction = UIAction(title: "New task", image: UIImage(systemName: "plus.circle.dashed")) { action in
            self.addNew(kind: .task)
        }
        let thirdAction = UIAction(title: "New Sub-task", image: UIImage(systemName: "plus.circle.dashed")) { action in
            self.addNew(kind: .subtask)
        }
        let elements: [UIAction] = [firstAction, secondAction/*, thirdAction*/]
        let menu = UIMenu(title: "", children: elements)
        btnAdd.showsMenuAsPrimaryAction = true
        btnAdd.menu = menu
    }
    
    private func configSelectOrgDropDown() {
        var elements: [UIAction] = []
        self.viewModel.organizations.forEach { item in
            let option = UIAction(title: item.name ?? "", image: nil) { [weak self] action in
                guard let self = self else { return }
                self.lblOrgName.text = item.name ?? ""
                self.viewModel.selectedOrganization = item
                //TODO: Call API get list task here
                self.viewModel.getListProject {
                    if self.viewModel.filteredProject.count == 0 {
                        self.lblNoti.isHidden = false
                        self.ivEmpty.isHidden = false
                        self.lblNoti.text = "No project\nStart your journey now!!!"
                        self.tableView.isHidden = true
                    } else {
                        self.lblNoti.isHidden = true
                        self.ivEmpty.isHidden = true
                        self.tableView.reloadData()
                        self.tableView.isHidden = false
                    }
                }
            }
            elements.append(option)
        }
        let menu = UIMenu(title: "", children: elements)
        btnSelectOrg.showsMenuAsPrimaryAction = true
        btnSelectOrg.menu = menu
    }
    
    private func addNew(kind: AddNewType) {
        let vc = FusionAddNewViewController(kind, organizationID: self.viewModel.selectedOrganization?.id)
        vc.viewModel.selectedOrganization = self.viewModel.selectedOrganization ?? OrganizationModel()
        vc.viewModel.projects = self.viewModel.projects
        vc.modalPresentationStyle = .fullScreen
        vc.addCompletion = { [weak self] in
            guard let self = self else { return }
            self.viewModel.getListProject {
                if self.viewModel.filteredProject.count == 0 {
                    self.lblNoti.text = "No project\nStart your journey now!!!"
                    self.tableView.isHidden = true
                } else {
                    self.ivEmpty.isHidden = true
                    self.lblNoti.isHidden = true
                    self.tableView.reloadData()
                    self.tableView.isHidden = false
                }
            }
        }
        self.present(vc, animated: true)
    }
    
    @IBAction func openSearchOnTap(_ sender: Any) {
        UIView.animate(withDuration: 0.25) {
            self.widthConstraintSearchBox.constant = UIScreen.main.bounds.width - 18
            self.view.layoutIfNeeded()
        }
    }
}
extension FusionProjectViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredProject.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellHeightExpanded = 120 + 20 + (57 * (self.viewModel.filteredProject[indexPath.row].taskInfos?.count ?? 0))
        return CGFloat(indexPathRowExpanded.contains(indexPath) ? cellHeightExpanded : 120)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! FusionTaskTableViewCell
        cell.bindingData(model: self.viewModel.filteredProject[indexPath.row])
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
        
        cell.tapDone = { [weak self] in
            guard let self = self else { return }
            self.viewModel.updateProject(id: self.viewModel.filteredProject[indexPath.row].id ?? 0, status: .done) {
                
                
            }
            self.viewModel.filteredProject.remove(at: indexPath.row)
            //Delete row at tableview
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.reloadData()
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
            //TODO:
            self.viewModel.deleteProject(id: self.viewModel.filteredProject[indexPath.row].id ?? 0) {
                
            }
            self.viewModel.filteredProject.remove(at: indexPath.row)
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
extension FusionProjectViewController: SearchBoxDelegate {
    func onSearch(keyword: String) {
        if keyword == "" {
            self.viewModel.filteredProject = self.viewModel.projects
        } else {
            self.viewModel.filteredProject = self.viewModel.projects.filter { item in
                (item.name ?? "").lowercased().contains(keyword.lowercased())
            }
        }
        self.tableView.reloadData()
    }
    
    func onCancel() {
        UIView.animate(withDuration: 0.25) {
            self.widthConstraintSearchBox.constant = 0
            self.view.layoutIfNeeded()
        }
    }
}

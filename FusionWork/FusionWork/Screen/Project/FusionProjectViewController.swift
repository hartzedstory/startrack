//
//  FusionProjectViewController.swift
//  StartTrack
//
//  Created by Hartzed Story on 13/3/25.
//

import UIKit

class FusionProjectViewController: UIViewController {
    @IBOutlet weak var lblOrgName: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnSelectOrg: UIButton!
    @IBOutlet weak var tableView: UITableView!
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
                self.tableView.reloadData()
                self.tableView.isHidden = false
            }
        }
        

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
        let elements: [UIAction] = [firstAction, secondAction, thirdAction]
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
                    self.tableView.reloadData()
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
                self.tableView.reloadData()
            }
        }
        self.present(vc, animated: true)
    }
}
extension FusionProjectViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.projects.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPathRowExpanded.contains(indexPath) ? 300 : 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! FusionTaskTableViewCell
        if self.viewModel.projects[indexPath.row].taskInfos?.count ?? 0 > 0 {
            cell.isHasSubTask = true
        } else {
            cell.isHasSubTask = false
        }
        
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
            self.viewModel.deleteProject(id: self.viewModel.projects[indexPath.row].id ?? 0) {
                
            }
            self.viewModel.projects.remove(at: indexPath.row)
            //Delete row at tableview
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        cell.bindingData(model: self.viewModel.projects[indexPath.row])
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
            self.viewModel.deleteProject(id: self.viewModel.projects[indexPath.row].id ?? 0) {
                
            }
            self.viewModel.projects.remove(at: indexPath.row)
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

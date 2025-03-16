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
    var mockNumber = [1,2,3,4,5]
    var mockOrg = ["IMM JSC", "VNPAY JSC"]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FusionTaskTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "cell")
        self.configAddDropDown()
        self.configSelectOrgDropDown()

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
        mockOrg.forEach { name in
            let option = UIAction(title: name, image: nil) { [weak self] action in
                guard let self = self else { return }
                self.lblOrgName.text = name
            }
            elements.append(option)
        }
        let menu = UIMenu(title: "", children: elements)
        btnSelectOrg.showsMenuAsPrimaryAction = true
        btnSelectOrg.menu = menu
    }
    
    private func addNew(kind: AddNewType) {
        let vc = FusionAddNewViewController(kind)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
}
extension FusionProjectViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mockNumber.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPathRowExpanded.contains(indexPath) ? 300 : 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! FusionTaskTableViewCell
        cell.isHasSubTask = true
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
            //TODO:
            self.mockNumber.remove(at: indexPath.row)
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

//
//  FusionProjectViewController.swift
//  StartTrack
//
//  Created by Hartzed Story on 13/3/25.
//

import UIKit

class FusionProjectViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var indexPathRowExpanded: Set<IndexPath> = []
    var mockNumber = [1,2,3,4,5]
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FusionTaskTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "cell")
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

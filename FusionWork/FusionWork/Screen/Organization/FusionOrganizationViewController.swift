//
//  FusionOrganizationViewController.swift
//  FusionWork
//
//  Created by HartzedStory on 5/3/25.
//

import UIKit

class FusionOrganizationViewController: UIViewController {

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
            self.tableView.reloadData()
        }
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
                self.tableView.reloadData()
            }
        }
        self.present(vc, animated: true)
    }
}

extension FusionOrganizationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.organizations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FusionOrganizationCell
        cell.lblName.text = self.viewModel.organizations[indexPath.row].name
        cell.closure = { [weak self] in
            guard let self = self else { return }
            self.viewModel.getOrganizationDetail(id: self.viewModel.organizations[indexPath.row].id ?? 0)
        }
        return cell
    }
    
    
}

//
//  FusionOrganizationViewController.swift
//  FusionWork
//
//  Created by HartzedStory on 5/3/25.
//

import UIKit

class FusionOrganizationViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        
    }
    
    private func configUI() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "FusionOrganizationCell", bundle: Bundle.main), forCellReuseIdentifier: "cell")
    }

    @IBAction func addOnTap(_ sender: Any) {
        self.addNew(kind: .organization)
    }
    
    private func addNew(kind: AddNewType) {
        let vc = FusionAddNewViewController(kind)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
}

extension FusionOrganizationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FusionOrganizationCell
        return cell
    }
    
    
}

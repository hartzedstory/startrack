//
//  FusionSelectPopupViewController.swift
//  FusionWork
//
//  Created by HartzedStory on 5/14/25.
//

import UIKit

protocol FusionSelectPopupDelete: AnyObject {
    func selectedAtIndex(index: Int)
}
class FusionSelectPopupViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var dataSource: [String] = []
    var delegate: FusionSelectPopupDelete?
    init() {
        super.init(nibName: "FusionSelectPopupViewController", bundle: Bundle.main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SelectPopupCell", bundle: Bundle.main), forCellReuseIdentifier: "cell")
        
    }

}

extension FusionSelectPopupViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! SelectPopupCell
        cell.lblTitle.text = self.dataSource[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.selectedAtIndex(index: indexPath.row)
        self.dismiss(animated: true)
    }
}

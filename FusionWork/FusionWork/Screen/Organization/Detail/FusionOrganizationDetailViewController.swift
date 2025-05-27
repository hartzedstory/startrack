//
//  FusionOrganizationDetailViewController.swift
//  FusionWork
//
//  Created by HartzedStory on 5/11/25.
//

import UIKit

class FusionOrganizationDetailViewController: UIViewController {
    
    @IBOutlet var headerView: HeaderView!
    @IBOutlet weak var doneInTotal: UILabel!
    @IBOutlet weak var notDoneInTotal: UILabel!
    @IBOutlet weak var vProgress: ProgressView!
    
    private var donePercentage: Int = 0
    private var done: Int
    private var notDone: Int
    private var total: Int
    private var orgName: String
    internal init(donePercentage: Int, done: Int, notDone: Int, total: Int, orgName: String) {
        self.donePercentage = donePercentage
        self.done = done
        self.notDone = notDone
        self.total = total
        self.orgName = orgName
        super.init(nibName: "FusionOrganizationDetailViewController", bundle: Bundle.main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.headerView.setTitle(title: orgName)
        self.doneInTotal.text = String(format: "%d/%d", self.done, self.total)
        self.notDoneInTotal.text = String(format: "%d/%d", self.notDone, self.total)
        vProgress.setProgress(to: CGFloat(self.donePercentage))
        headerView.hideRightImage()
    }
    
    deinit {
        self.headerView = nil
    }
}

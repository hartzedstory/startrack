//
//  AddSubTaskView.swift
//  FusionWork
//
//  Created by HartzedStory on 5/14/25.
//

import Foundation
import UIKit

protocol AddSubTaskViewDelegate: AnyObject {
    func onShowDetailSubtask()
}
class AddSubTaskView: UIView {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    
    var viewModel = AddSubTaskViewModel()
    var delegate: AddSubTaskViewDelegate?
    init(_ title: String, delegate: UIViewController) {
        super.init(frame: .zero)
        commonInit()
        self.lblTitle.text = title
        self.delegate = delegate as? any AddSubTaskViewDelegate
        configTableView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        configTableView()
    }
    
    func commonInit() {
        let nib = UINib(nibName: "AddSubTaskView", bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)

    }
    
    private func configTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "FusionAddSubtaskCell", bundle: Bundle.main), forCellReuseIdentifier: "cell")
    }
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 220)
    }
    
    @IBAction func addSubtaskOnTap(_ sender: Any) {
        
    }
}

extension AddSubTaskView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.subTaskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FusionAddSubtaskCell
        cell.onDetail = { [weak self] in
            guard let self = self else { return }
            self.delegate?.onShowDetailSubtask()
        }
        return cell
    }
    
    
}

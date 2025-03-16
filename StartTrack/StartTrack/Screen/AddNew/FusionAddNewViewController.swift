//
//  FusionAddNewViewController.swift
//  StartTrack
//
//  Created by HartzedStory on 3/16/25.
//

import UIKit
enum AddNewType: String {
    case project = "New Project"
    case task = "New Task"
    case subtask = "New sub-task"
}

class FusionAddNewViewController: UIViewController {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var vDoneContainer: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var vScrollViewContent: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var vAddContainer: UIView!
    @IBOutlet weak var heightContainer: NSLayoutConstraint!
    
    
    var arrAtomicView: [UIView] = []
    internal var addNewType: AddNewType = .task
    var viewModel = FusionAddNewViewModel()
    
    init(_ type:AddNewType) {
        self.addNewType = type
        super.init(nibName: "FusionAddNewViewController", bundle: Bundle.main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI(forKind: addNewType)
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configUI(forKind: AddNewType) {
        self.lblTitle.text = self.addNewType.rawValue
        vAddContainer.layer.cornerRadius = vAddContainer.frame.height / 2
        switch forKind {
        case .project:
            self.layoutStackView(arrView: arrAtomicView)
        case .task:
            self.arrAtomicView = [
                FusionInputView("Title1", UIImage(named: "")),
                Spacer(height: 21),
                FusionInputView("Title2", UIImage(named: "")),
                Spacer(height: 21),
                FusionInputView("Title3", UIImage(named: "")),
                Spacer(height: 21),
                FusionInputView("Title4", UIImage(named: "")),
                Spacer(height: 21),
                FusionInputView("Title4", UIImage(named: "")),
                Spacer(height: 21),
                FusionInputView("Title4", UIImage(named: "")),
                Spacer(height: 21),
                FusionInputView("Title4", UIImage(named: "")),
                Spacer(height: 21),
                FusionInputView("Title4", UIImage(named: "")),
                Spacer(height: 21),
                FusionInputView("Title4", UIImage(named: "")),
            ]
            self.layoutStackView(arrView: arrAtomicView)
        case .subtask:
            self.layoutStackView(arrView: arrAtomicView)
        }
    }
    
    @IBAction func dismissOnTap(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

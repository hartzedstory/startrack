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
    case organization = "New Organization"
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
    var addCompletion: (() -> Void)?
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
                FusionInputView(.projectName, UIImage(named: ""), delegate: self),
                Spacer(height: 21),
                FusionInputView(.title, UIImage(named: ""), delegate: self),
                Spacer(height: 21),
                FusionInputView(.dateStart, UIImage(named: "ic_calendar_small"), delegate: self),
                Spacer(height: 21),
                FusionInputView(.dateEnd, UIImage(named: "ic_calendar_small"), delegate: self),
                Spacer(height: 21),
                AddMemberView("Thành viên"),
                Spacer(height: 21),
            ]
            self.layoutStackView(arrView: arrAtomicView)
        case .subtask:
            self.layoutStackView(arrView: arrAtomicView)
        case .organization:
            self.arrAtomicView = [
                FusionInputView(.orgName, UIImage(named: ""), delegate: self),
                Spacer(height: 21),
                FusionInputView(.orgOwner, UIImage(named: ""), delegate: self),
                Spacer(height: 21),
                AddMemberView("Thành viên"),
                Spacer(height: 21),
            ]
            self.layoutStackView(arrView: arrAtomicView)
        }
    }
    
    @IBAction func createOnTap(_ sender: Any) {
        switch self.addNewType {
        case .project:
            break
        case .task:
            break
        case .subtask:
            break
        case .organization:
            let model = OrganizationInitializeModel()
            model.name = viewModel.orgName
            model.owner = viewModel.orgOwner
            model.userId = [GlobalData.sharedInstance.user.userId ?? 0]
            model.tasks = []
            self.viewModel.createOrganization(model: model) { [weak self] in
                guard let self = self else { return }
                if let action = self.addCompletion {
                    action()
                    self.dismiss(animated: true)
                }
            }
        }
    }
    
    @IBAction func dismissOnTap(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

extension FusionAddNewViewController: FusionInputTextDelegate {
    func inputValue(type: AddInputFieldType, value: String) {
        self.viewModel.handleInputData(type: type, value: value)
    }
}

//
//  FusionAddNewViewController.swift
//  StartTrack
//
//  Created by HartzedStory on 3/16/25.
//

import UIKit

protocol FusionAddNewViewDelegate: AnyObject {
    func submitSubtask(subtask: SubtaskInitializeModel)
}
enum AddNewType: String {
    case project = "New Project"
    case task = "New Task"
    case subtask = "New Sub-task"
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
    var isAddSubtaskInside = false
    var delegate: FusionAddNewViewDelegate?
    internal var addNewType: AddNewType = .task
    var viewModel = FusionAddNewViewModel()
    
    init(_ type:AddNewType, organizationID: Int? = nil) {
        self.addNewType = type
        self.viewModel.organizationID = organizationID
        super.init(nibName: "FusionAddNewViewController", bundle: Bundle.main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configUI(forKind: addNewType)
        hideKeyboardWhenTappedAround()
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configUI(forKind: AddNewType) {
        self.lblTitle.text = self.addNewType.rawValue
        vAddContainer.layer.cornerRadius = vAddContainer.frame.height / 2
        switch forKind {
        case .project:
            self.arrAtomicView = [
                FusionInputView(.projectName, delegate: self),
                Spacer(height: 21),
                FusionInputView(.title, delegate: self),
                Spacer(height: 21),
                FusionInputView(.dateStart, UIImage(named: "ic_calendar_small"), onRightTap: { [weak self] in
                    guard let self = self else { return }
                    self.openDatePickerView()
                }, delegate: self),
                Spacer(height: 21),
                FusionInputView(.dateEnd, UIImage(named: "ic_calendar_small"), onRightTap: { [weak self] in
                    guard let self = self else { return }
                    self.openDatePickerView()
                }, delegate: self),
                Spacer(height: 21),
                AddMemberView("Member(s)", self.viewModel.organizationID ?? 0, delegate: self),
                Spacer(height: 21),
                StateView("Status", delegate: self),
                Spacer(height: 21),
                DescriptionView("Description", delegate: self),
                Spacer(height: 21),
            ]
            self.layoutStackView(arrView: arrAtomicView)
        case .task:
            self.arrAtomicView = [
                FusionInputView(.taskName, delegate: self),
                Spacer(height: 21),
                FusionInputView(.projectName, UIImage(named: "ic_dropdown"), onRightTap: { [weak self] in
                    guard let self = self else { return }
                    let vc = FusionSelectPopupViewController()
                    vc.modalPresentationStyle = .automatic
                    
                    var tempList: [String] = []
                    self.viewModel.projects.forEach { item in
                        tempList.append(item.name ?? "")
                    }
                    vc.delegate = self
                    vc.dataSource = tempList
                    self.present(vc, animated: true)
                }, delegate: self),
                Spacer(height: 21),
                FusionInputView(.dateStart, UIImage(named: "ic_calendar_small"), onRightTap: { [weak self] in
                    guard let self = self else { return }
                    self.openDatePickerView()
                }, delegate: self),
                Spacer(height: 21),
                FusionInputView(.dateEnd, UIImage(named: "ic_calendar_small"), onRightTap: { [weak self] in
                    guard let self = self else { return }
                    self.openDatePickerView()
                }, delegate: self),
                Spacer(height: 21),
                StateView("Status", delegate: self),
                Spacer(height: 21),
                AddSubTaskView("Sub-Task", delegate: self),
                Spacer(height: 21)
            ]
            self.layoutStackView(arrView: arrAtomicView)
        case .subtask:
            if self.isAddSubtaskInside {
                self.arrAtomicView = [
                    FusionInputView(.subTaskName, delegate: self),
                    Spacer(height: 21),
                    FusionInputView(.dateStart, UIImage(named: "ic_calendar_small"), onRightTap: { [weak self] in
                        guard let self = self else { return }
                        self.openDatePickerView()
                    }, delegate: self),
                    Spacer(height: 21),
                    FusionInputView(.dateEnd, UIImage(named: "ic_calendar_small"), onRightTap: { [weak self] in
                        guard let self = self else { return }
                        self.openDatePickerView()
                    }, delegate: self),
                    Spacer(height: 21),
                    StateView("Status", delegate: self),
                    Spacer(height: 21),
                ]
            } else {
                self.arrAtomicView = [
                FusionInputView(.subTaskName, delegate: self),
                Spacer(height: 21),
                FusionInputView(.taskName, UIImage(named: "ic_dropdown"), onRightTap: { [weak self] in
                    guard let self = self else { return }
                    let vc = FusionSelectPopupViewController()
                    vc.modalPresentationStyle = .automatic
                    
                    var tempList: [String] = []
                    self.viewModel.projects.forEach { item in
                        item.taskInfos?.forEach { atomicItem in
                            tempList.append(atomicItem.taskName ?? "")
                        }
                    }
                    vc.delegate = self
                    vc.dataSource = tempList
                    self.present(vc, animated: true)
                }, delegate: self),
                Spacer(height: 21),
                FusionInputView(.dateStart, UIImage(named: "ic_calendar_small"), onRightTap: { [weak self] in
                    guard let self = self else { return }
                    self.openDatePickerView()
                }, delegate: self),
                Spacer(height: 21),
                FusionInputView(.dateEnd, UIImage(named: "ic_calendar_small"), onRightTap: { [weak self] in
                    guard let self = self else { return }
                    self.openDatePickerView()
                }, delegate: self),
                Spacer(height: 21),
                StateView("Status", delegate: self),
                Spacer(height: 21),
                ]
            }
            self.layoutStackView(arrView: arrAtomicView)
        case .organization:
            self.arrAtomicView = [
                FusionInputView(.orgName, delegate: self),
                Spacer(height: 21),
                FusionInputView(.orgOwner, delegate: self),
                Spacer(height: 21),
                AddMemberView("Member(s)", self.viewModel.organizationID ?? 0, delegate: self),
                Spacer(height: 21),
            ]
            self.layoutStackView(arrView: arrAtomicView)
        }
    }
    
    private func openDatePickerView() {
    
    }
    
    @IBAction func createOnTap(_ sender: Any) {
        switch self.addNewType {
        case .project:
            let model = ProjectInitializeModel()
            model.name = viewModel.projectName
            model.title = viewModel.title
            model.startDate = viewModel.dateStart
            model.endDate = viewModel.dateEnd
            model.members = []
            self.viewModel.memberList.forEach { member in
                model.members?.append(member.id ?? 0)
            }
            model.priority = viewModel.priority.rawValue
            model.description = viewModel.descriptionText
            model.organizationId = viewModel.organizationID
            if self.validateField(forKind: .project) {
                self.viewModel.createProject(model: model) { response in
                    if let action = self.addCompletion {
                        action()
                        self.dismiss(animated: true)
                    }
                } onError: { error in
                    self.showAlert(message: error)
                }
            }
            break
        case .task:
            let model = TaskInitializeModel()
            model.name = viewModel.taskName
            model.projectId = viewModel.tempSelectProject.id
            model.startDate = viewModel.dateStart
            model.endDate = viewModel.dateEnd
            model.priority = viewModel.priority.rawValue
            model.subTasks = viewModel.listSubtask
            if self.validateField(forKind: .task) {
                self.viewModel.createTask(model: model) { response in
                    if let action = self.addCompletion {
                        action()
                        self.dismiss(animated: true)
                    }
                } onError: { error in
                    self.showAlert(message: error)
                }
            }
            break
        case .subtask:
            if isAddSubtaskInside {
                let model = SubtaskInitializeModel()
                model.name = viewModel.subTaskName
                model.startDate = viewModel.dateStart
                model.endDate = viewModel.dateEnd
                model.priority = viewModel.priority.rawValue
                if self.validateField(forKind: .subtask) {
                    self.dismiss(animated: true) {
                        self.delegate?.submitSubtask(subtask: model)
                    }
                }
            } else {
                let model = SubtaskInitializeModel()
                model.name = viewModel.subTaskName
                
                model.startDate = viewModel.dateStart
                model.endDate = viewModel.dateEnd
                model.priority = viewModel.priority.rawValue
                if self.validateField(forKind: .subtask) {
                    self.dismiss(animated: true) {
                        self.delegate?.submitSubtask(subtask: model)
                    }
                }
            }
            break
        case .organization:
            let model = OrganizationInitializeModel()
            model.name = viewModel.orgName
            model.owner = viewModel.orgOwner
            model.userId = [GlobalData.sharedInstance.user.userId ?? 0]
            model.tasks = []
            if self.validateField(forKind: .organization) {
                self.viewModel.createOrganization(model: model) { [weak self] in
                    guard let self = self else { return }
                    if let action = self.addCompletion {
                        action()
                        self.dismiss(animated: true)
                    }
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

extension FusionAddNewViewController: AddMemberViewDelegate {
    func memberList(list: [MemberModel]) {
        self.viewModel.memberList = list
    }
    
    func errorReturn(message: String) {
        self.showAlert(message: message)
    }
}

extension FusionAddNewViewController: StateDelegate {
    func value(state: State) {
        self.viewModel.priority = state
    }
}

extension FusionAddNewViewController: DescriptionViewDelegate {
    func value(text: String) {
        self.viewModel.descriptionText = text
    }
}

extension FusionAddNewViewController: FusionSelectPopupDelete {
    func selectedAtIndex(index: Int) {
        self.viewModel.tempSelectProject = self.viewModel.projects[index]
        (self.stackView.arrangedSubviews[2] as? FusionInputView)?.textField.text = self.viewModel.projects[index].name
    }
}

extension FusionAddNewViewController: AddSubTaskViewDelegate {
    func onPresentAddNewSubtask() {
        let vc = FusionAddNewViewController(.subtask)
        vc.modalPresentationStyle = .fullScreen
        vc.isAddSubtaskInside = true
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    func onShowDetailSubtask() {
        
    }
}

//MARK - Case add subtask inside
extension FusionAddNewViewController: FusionAddNewViewDelegate {
    func submitSubtask(subtask: SubtaskInitializeModel) {
        self.viewModel.listSubtask.append(subtask)
        (self.stackView.arrangedSubviews[10] as! AddSubTaskView).viewModel.subTaskList = self.viewModel.listSubtask
        (self.stackView.arrangedSubviews[10] as! AddSubTaskView).tableView.reloadData()
    }
}

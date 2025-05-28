//
//  AddMemberView.swift
//  StartTrack
//
//  Created by HartzedStory on 3/17/25.
//

import UIKit

protocol AddMemberViewDelegate: AnyObject {
    func errorReturn(message: String)
    func memberList(list: [MemberModel])
}
class AddMemberView: UIView {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var vTextField: UIView!
    @IBOutlet weak var vTextbox: UIView!
    @IBOutlet weak var vMember: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var onRightTap: (() -> Void)?
    var viewModel = AddMemberViewModel()
    var delegate: AddMemberViewDelegate?
    init(_ title: String, _ organizationID: Int, delegate: UIViewController) {
        super.init(frame: .zero)
        commonInit()
        self.viewModel.organizationID = organizationID
        self.delegate = delegate as? any AddMemberViewDelegate
        configure(title: title)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func configure(title: String) {
        lblTitle.text = title
        vTextField.layer.cornerRadius = 18
        vTextbox.layer.cornerRadius = 12.5
        vTextbox.layer.cornerRadius = 12.5
        configUI()
    }
    
    func commonInit() {
        let nib = UINib(nibName: "AddMemberView", bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 150)
    }
    
    func configUI() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "MemberCell", bundle: Bundle.main), forCellWithReuseIdentifier: "cell")
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.scrollDirection = .vertical // để nó wrap xuống dòng

        collectionView.collectionViewLayout = layout
        collectionView.isScrollEnabled = true
        collectionView.alwaysBounceVertical = true

        if let action = onRightTap {
            action()
        }
    }
    
    func validateEmail() -> Bool{
        if self.textField.text?.isEmpty == true {
            return false
        }
        
        if let stringValue = self.textField.text {
            if (stringValue.contains("@")) {} else {
                return false
            }
            
            if (stringValue.contains(".")) {} else {
                return false
            }
        }
        
        return true
    }
    
    @IBAction func addOnTap(_ sender: Any) {
        if validateEmail() {
            self.viewModel.findUser(email: self.textField.text ?? "") { userList in
                self.viewModel.memberList.append(userList.first ?? MemberModel())
                self.delegate?.memberList(list: self.viewModel.memberList)
            } onError: { error in
                self.delegate?.errorReturn(message: "The user is not found. Please check one more time")
            }

        } else {
            self.delegate?.errorReturn(message: "Email is not in correct format. Please check one more time")
        }
    }
    
    @IBAction func onChange(_ sender: Any) {
        self.viewModel.inputEmail = self.textField.text ?? ""
    }
}

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.representedElementCategory == .cell {
                if layoutAttribute.frame.origin.y >= maxY {
                    leftMargin = sectionInset.left
                }

                layoutAttribute.frame.origin.x = leftMargin
                leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
                maxY = max(layoutAttribute.frame.maxY, maxY)
            }
        }

        return attributes
    }
}

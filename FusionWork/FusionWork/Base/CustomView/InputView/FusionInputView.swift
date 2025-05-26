//
//  FusionInputView.swift
//  StartTrack
//
//  Created by HartzedStory on 3/16/25.
//

import UIKit

protocol FusionInputTextDelegate: AnyObject {
    func inputValue(type: AddInputFieldType, value: String)
}
class FusionInputView: UIView {
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var vTextField: UIView!
    @IBOutlet var ivRightImage: UIImageView!
    @IBOutlet var textField: UITextField!
    @IBOutlet weak var widthConstraintImage: NSLayoutConstraint!
    
    var inputType: AddInputFieldType?
    var onRightTap: (() -> Void)?
    var delegate: FusionInputTextDelegate?

    private let datePicker = UIDatePicker()
    
    init(_ title: AddInputFieldType, _ image: UIImage? = nil, onRightTap: (() -> Void)? = nil, delegate: UIViewController) {
        super.init(frame: .zero)
        commonInit()
        configure(title: title.rawValue, image: image, onRightTap: onRightTap, delegate: delegate)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func configure(title: String, image: UIImage?, onRightTap: (() -> Void)?, delegate: UIViewController) {
        lblTitle.text = title
        if let _image = image {
            ivRightImage.image = image
        } else {
            widthConstraintImage.constant = 0
        }
        
        self.onRightTap = onRightTap
        vTextField.layer.cornerRadius = 18
        self.delegate = delegate as? any FusionInputTextDelegate
        self.inputType = AddInputFieldType(rawValue: title)
        
        switch inputType {
        case .dateStart, .dateEnd:
            if #available(iOS 13.4, *) {
                datePicker.preferredDatePickerStyle = .compact
            }
            datePicker.datePickerMode = .dateAndTime
            datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
            
            let container = UIView(frame: .init(x: 0, y: 0, width: 0, height: 0))
            container.addSubview(datePicker)
            datePicker.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                datePicker.bottomAnchor.constraint(equalTo: container.safeAreaLayoutGuide.bottomAnchor),
                datePicker.topAnchor.constraint(equalTo: container.safeAreaLayoutGuide.topAnchor),
                datePicker.leadingAnchor.constraint(equalTo: container.safeAreaLayoutGuide.leadingAnchor),
                datePicker.trailingAnchor.constraint(equalTo: container.safeAreaLayoutGuide.trailingAnchor),
            ])
            textField.inputView = datePicker
            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donePressed))
            toolbar.setItems([doneButton], animated: true)
            textField.inputAccessoryView = toolbar
        case .projectName, .taskName, .subTaskName, .title, .orgName, .orgOwner:
            break
        case .inProject:
            break
        case .none, .some(.none):
            break
        }
    }
    
    func commonInit() {
        let nib = UINib(nibName: "FusionInputView", bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: 72)
    }
    
    @objc private func dateChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        textField.text = formatter.string(from: sender.date)
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd/MM/yyyy HH:mm" // format bạn đã dùng để hiển thị
        inputFormatter.timeZone = TimeZone.current
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        outputFormatter.timeZone = TimeZone(secondsFromGMT: 0) // quan trọng để ra "Z" (UTC)

        if let date = inputFormatter.date(from: textField.text ?? "") {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            outputFormatter.timeZone = TimeZone(secondsFromGMT: 0)

            let result = outputFormatter.string(from: date)
            print(result)
            self.delegate?.inputValue(type: self.inputType ?? .none, value: result)
        } else {
            print("⛔️ Không thể chuyển text sang ngày")
        }
    }
    
    @objc private func donePressed() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy HH:mm"
        textField.text = formatter.string(from: datePicker.date)
        textField.resignFirstResponder()
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd/MM/yyyy HH:mm" // format bạn đã dùng để hiển thị
        inputFormatter.timeZone = TimeZone.current
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        outputFormatter.timeZone = TimeZone(secondsFromGMT: 0) // quan trọng để ra "Z" (UTC)

        if let date = inputFormatter.date(from: textField.text ?? "") {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            outputFormatter.timeZone = TimeZone(secondsFromGMT: 0)

            let result = outputFormatter.string(from: date)
            print(result)
            self.delegate?.inputValue(type: self.inputType ?? .none, value: result)
        } else {
            print("⛔️ Không thể chuyển text sang ngày")
        }
    }

    
    @IBAction func onChangeValue(_ sender: Any) {
        switch inputType {
        case .dateStart, .dateEnd:
            break
        case .projectName, .taskName, .subTaskName, .title, .orgName, .orgOwner:
            self.delegate?.inputValue(type: self.inputType ?? .none, value: self.textField.text ?? "")
        case .inProject:
            break
        case .none, .some(.none):
            break
        }

    }
    
    @IBAction func rightOnAction(_ sender: Any) {
        if let action = onRightTap {
            action()
        }
    }
}

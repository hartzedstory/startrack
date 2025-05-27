//
//  FusionNotificationCell.swift
//  FusionWork
//
//  Created by Hartzed Story on 27/5/25.
//

import UIKit

class FusionNotificationCell: UITableViewCell {

    @IBOutlet weak var ivCheck: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var vSeparator: UIView!
    var closure: (() -> Void)?
    var isChecked: Bool = false
    var type: FusionNotificationType = .unread
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bindingData(model: NotificationModel, type: FusionNotificationType) {
        ivCheck.isHighlighted = model.isRead ?? false
        isChecked = model.isRead ?? false
        lblTitle.text = model.subject
        self.type = type
        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"

        if let date = inputFormatter.date(from: model.createdDatetime ?? "") {
            let outputFormatter = DateFormatter()
            outputFormatter.locale = Locale(identifier: "en_US_POSIX")
            outputFormatter.dateFormat = "dd/MM/yyyy HH:mm"
            
            let formattedString = outputFormatter.string(from: date)
            lblTime.text = formattedString
        } else {
            print("Không thể parse ngày từ chuỗi.")
        }
    }
    
    func hideSeparator() {
        self.vSeparator.isHidden = true
    }
    
    @IBAction func onTap(_ sender: Any) {
        switch type {
        case .unread:
            isChecked = !isChecked
            ivCheck.isHighlighted = isChecked
            if let action = closure {
                action()
            }
        case .read:
            //Ignore
            break
        }
    }
}

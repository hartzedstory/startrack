//
//  FusionOrganizationCell.swift
//  FusionWork
//
//  Created by HartzedStory on 5/3/25.
//

import UIKit

class FusionOrganizationCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCreator: UILabel!
    @IBOutlet weak var vMain: UIView!
    var closure: (()->Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        vMain.layer.cornerRadius = 20
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func onTap(_ sender: Any) {
        if let action = closure {
            action()
        }
    }
}

//
//  FusionAddSubtaskCell.swift
//  FusionWork
//
//  Created by HartzedStory on 5/22/25.
//

import UIKit

class FusionAddSubtaskCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    var onDetail: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func showOnDetail(_ sender: Any) {
        if let action = onDetail {
            action()
        }
    }
}

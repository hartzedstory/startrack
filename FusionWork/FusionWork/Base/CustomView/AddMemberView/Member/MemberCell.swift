//
//  MemberCell.swift
//  FusionWork
//
//  Created by HartzedStory on 5/13/25.
//

import UIKit

class MemberCell: UICollectionViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    var onDelete: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func bindingData(item: MemberModel) {
        self.lblTitle.text = item.name
    }
    @IBAction func deleteAction(_ sender: Any) {
        if let action = onDelete {
            action()
        }
    }
}

//
//  SearchBox.swift
//  FusionWork
//
//  Created by Hartzed Story on 26/5/25.
//

import Foundation
import UIKit

protocol SearchBoxDelegate: AnyObject {
    func onCancel()
    func onSearch(keyword: String)
}
class SearchBox: UIView {
    
    @IBOutlet weak var vSearchContainer: UIView!
    @IBOutlet weak var vContainer: UIView!
    @IBOutlet weak var textField: UITextField!
    var delegate: SearchBoxDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.commonInit()
        self.vContainer.clipsToBounds = true
        self.vSearchContainer.layer.cornerRadius = 16
        self.vSearchContainer.layer.borderWidth = 1
        self.vSearchContainer.layer.borderColor = UIColor(hex: "#EDEDED").cgColor
    }
    
    func commonInit() {
        let nib = UINib(nibName: "SearchBox", bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }
        
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }
    
    @IBAction func onCancel(_ sender: Any) {
        self.delegate?.onCancel()
    }
    
    @IBAction func onSearching(_ sender: Any) {
        if let text = textField.text {
            self.delegate?.onSearch(keyword: text)
        }
    }
    
}

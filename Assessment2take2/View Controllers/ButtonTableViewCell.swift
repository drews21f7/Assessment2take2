//
//  ButtonTableViewCell.swift
//  Assessment2take2
//
//  Created by Drew Seeholzer on 6/23/19.
//  Copyright © 2019 Drew Seeholzer. All rights reserved.
//

import UIKit

protocol ButtonTableViewCellDelegate {
    func buttonCellButtonTapped (_ sender: ButtonTableViewCell)
}

class ButtonTableViewCell: UITableViewCell {
    
    @IBOutlet weak var itemLabel: UILabel!
    
    @IBOutlet weak var checkedButton: UIButton!
    
    var delegate: ButtonTableViewCellDelegate?
    
    fileprivate func updateButton(_ isChecked: Bool) {
        let imageName = isChecked ? "complete" : "incomplete"
        checkedButton.setImage(UIImage(named: imageName), for: .normal)
    }
    
    func update(withItem item: List) {
        itemLabel.text = item.item
        updateButton(item.isChecked)
    }
    
    @IBAction func checkedButtonTapped(_ sender: Any) {
        delegate?.buttonCellButtonTapped(self)
    }
}

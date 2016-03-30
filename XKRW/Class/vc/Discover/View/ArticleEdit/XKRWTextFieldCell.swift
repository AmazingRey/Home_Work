//
//  XKRWTextFieldCell.swift
//  XKRW
//
//  Created by Klein Mioke on 15/9/21.
//  Copyright © 2015年 XiKang. All rights reserved.
//

import UIKit

class XKRWTextFieldCell: UITableViewCell {

    @IBOutlet weak var topLine: UIView!
    @IBOutlet weak var bottomLine: UIView!
    
    @IBOutlet weak var bottomLineLeadingSpace: NSLayoutConstraint!
    @IBOutlet weak var topLineLeadingSpace: NSLayoutConstraint!
    
    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.textField.delegate = self
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension XKRWTextFieldCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        return true
    }
}

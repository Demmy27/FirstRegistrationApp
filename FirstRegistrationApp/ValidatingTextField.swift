//
// Created by Shishov Dmitry on 2019-01-16.
// Copyright (c) 2019 Shishov Dmitry. All rights reserved.
//


import UIKit
import UnderLineTextField

class ValidatingTextField: UnderLineTextField {

    var valid: (Bool, String) = (false, "") {
        didSet {
            configureForValid()
        }
    }

    var hasBeenExited: Bool = false {
        didSet {
            configureForValid()
        }
    }

    func commonInit() {
        configureForValid()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func resignFirstResponder() -> Bool {
        hasBeenExited = true
        return super.resignFirstResponder()
    }

    private func configureForValid() {
        if !valid.0 && text != "" {
            self.status = .error
            self.errorLabel.text = valid.1
        } else {
            self.status = .normal
            self.errorLabel.text = ""
        }
    }
}

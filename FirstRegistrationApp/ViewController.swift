//
//  ViewController.swift
//  FirstRegistrationApp
//
//  Created by Demmy on 11/01/2019.
//  Copyright © 2019 Demmy. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {

    @IBOutlet weak var NameTextField: UITextField!
    @IBOutlet weak var EmailTextFileld: UITextField!
    @IBOutlet weak var PasswordTextFiled: UITextField!
    
    private let disposeBag = DisposeBag()
    private let throttleInterval = 0.1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    let nameValid = NameTextField.rx.text
        .throttle(throttleInterval, scheduler: MainScheduler.instance)
        .observeOn(MainScheduler.instance)
        
        
        nameValid.subscribe { (event) in
            print("\(event)")
        }
    }
    
}


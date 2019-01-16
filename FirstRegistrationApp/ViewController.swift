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
import Toast_Swift

//import RxOptional

class ViewController: UIViewController {

    @IBOutlet weak var nameTextField: ValidatingTextField!
    @IBOutlet weak var emailTextField: ValidatingTextField!
    @IBOutlet weak var passwordTextFiled: ValidatingTextField!
    @IBOutlet weak var registrationButton: UIButton!

    private let disposeBag = DisposeBag()
    private let throttleInterval = 0.1

    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTextChangeHandling()
    }

    // MARK: - Methods
    private func validate(name: String?) -> (Bool, String) {
        guard let name = name, !name.isEmpty else {
            return (false, "Name is empty")
        }

        return (1...6 ~= name.count, "Name validation error")
    }

    private func validate(password: String?) -> (Bool, String) {
        guard let password = password, !password.isEmpty else {
            return (false, "Password is empty")
        }

        return (1...6 ~= password.count, "Password validation error")
    }

    private func validate(email: String?) -> (Bool, String) {
        guard let email = email, !email.isEmpty else {
            return (false, "Email is empty")
        }

        return (1...6 ~= email.count, "Email validation error")
    }

    private func validForm() -> (isValid: Bool, errorString: String) {
        return (true, "")// isAllValid?.value ?? (false, "Unknown error")
    }

    //MARK: - RX Setup
    private func setupTextChangeHandling() {

        let nameValid = nameTextField
                .rx
                .text
                .throttle(throttleInterval, scheduler: MainScheduler.instance)
                .map {
                    self.validate(name: $0)
                }

        nameValid
                .subscribe(onNext: { self.nameTextField.valid = $0 })
                .disposed(by: disposeBag)

        let passValid = passwordTextFiled
                .rx
                .text
                .throttle(throttleInterval, scheduler: MainScheduler.instance)
                .map {
                    self.validate(password: $0)
                }

        passValid
                .subscribe(onNext: { self.passwordTextFiled.valid = $0 })
                .disposed(by: disposeBag)

        let emailValid = emailTextField
                .rx
                .text
                .throttle(throttleInterval, scheduler: MainScheduler.instance)
                .map {
                    self.validate(email: $0)
                }

        emailValid
                .subscribe(onNext: { self.emailTextField.valid = $0 })
                .disposed(by: disposeBag)

        let everythingValid = Observable
                .combineLatest(nameValid, passValid, emailValid) {
                    ($0.0 && $1.0 && $2.0, $0.1 + $1.1 + $2.1)
                }

        everythingValid
                .map({ $0.0 })
                .bind(to: registrationButton.rx.isEnabled)
                .disposed(by: disposeBag)

        registrationButton.rx.tap
                .do(onNext: { [unowned self] in
                    self.nameTextField.resignFirstResponder()
                    self.emailTextField.resignFirstResponder()
                    self.passwordTextFiled.resignFirstResponder()
                }).subscribe(onNext: { [unowned self] in
            let validationResult = self.validForm()
            if validationResult.isValid {
                self.view.makeToast("Login Success!")
            } else {
                self.view.makeToast(validationResult.errorString)
            }
        }).disposed(by: disposeBag)
    }
}


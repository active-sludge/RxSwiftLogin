//
//  ViewController.swift
//  LoginRxSwift
//
//  Created by Huseyin Can Dayan on 11.09.2020.
//  Copyright © 2020 Huseyin Can Dayan. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    private let loginViewModel = LoginViewModel()
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var userNameTextFieild: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func tappedLoginButton(_ sender: UIButton) {
        print("tapped Login button")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userNameTextFieild.becomeFirstResponder()
    
        userNameTextFieild.rx.text.map { $0 ?? "" }.bind(to: loginViewModel.usernameTextPublishSubject).disposed(by: disposeBag)
        passwordTextField.rx.text.map { $0 ?? "" }.bind(to: loginViewModel.passwordTextPublishSubject).disposed(by: disposeBag)
        
        loginViewModel.isValid().bind(to: loginButton.rx.isEnabled).disposed(by: disposeBag)
        loginViewModel.isValid().map { $0 ? 1 : 0.1 }.bind(to: loginButton.rx.alpha).disposed(by: disposeBag)
        
    }
}

class LoginViewModel {
    
    let usernameTextPublishSubject = PublishSubject<String>()
    let passwordTextPublishSubject = PublishSubject<String>()
    
    func isValid() -> Observable<Bool> {
        return Observable.combineLatest(usernameTextPublishSubject.asObserver().startWith(""), passwordTextPublishSubject.asObserver().startWith("")).map { username, password in
            return username.count > 3 && password.count > 3
        }.startWith(false)
    }
}


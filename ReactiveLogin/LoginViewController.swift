//
// Copyright © 2018 Bitsden. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!

    private let disposeBag =  DisposeBag()
    private lazy var presenter: LoginPresenter = {
        let userEventProvider = LoginPresenter.UserEventProvider(
            usernameChanged: usernameTextField.rx.value.asObservable(),
            passwordChanged: passwordTextField.rx.value.asObservable()
        )
        return LoginPresenter(userEventProvider: userEventProvider)
    }()


    override func viewDidLoad() {
        super.viewDidLoad()

        let isValidObservable = presenter.isValid.share()
        isValidObservable
            .asDriver(onErrorJustReturn: false)
            .drive(loginButton.rx.isEnabled)
            .disposed(by: disposeBag)

        let buttonColorObservable = isValidObservable.map { $0 ? UIColor.blue : UIColor.gray }
        Observable.concat(Observable.just(UIColor.gray), buttonColorObservable)
            .bind { [weak self] in
                self?.loginButton.backgroundColor = $0
            }
            .disposed(by: disposeBag)
    }

}

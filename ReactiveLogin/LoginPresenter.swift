//
// Copyright © 2018 Bitsden. All rights reserved.
//

import Foundation
import RxSwift

struct LoginCredential: Equatable {
    static let empty = LoginCredential(username: "", password: "")

    let username: String
    let password: String

    var isValid: Bool {
        return !username.isEmpty && !password.isEmpty
    }

    static func ==(lhs: LoginCredential, rhs: LoginCredential) -> Bool {
        return lhs.username == rhs.username && lhs.password == rhs.password
    }
}

struct LoginPresenter {
    let isValid: Observable<Bool>
    let credential: Observable<LoginCredential>

    init(username: Observable<String>, password: Observable<String>) {
        isValid = Observable.concat(Observable.from(optional: false), LoginPresenter.isValidObservable(username, password))
        credential = Observable.concat(Observable.from(optional: .empty), LoginPresenter.credentialObservable(username, password))
    }

    private static func isValidObservable(_ username: Observable<String>, _ password: Observable<String>) -> Observable<Bool> {
        return Observable.zip(username, password) { username, password in
            let credential = LoginCredential(username: username, password: password)
            return credential.isValid
        }
    }

    private static func credentialObservable(_ username: Observable<String>, _ password: Observable<String>) -> Observable<LoginCredential> {
        return Observable.zip(username, password) { username, password in
            let credential = LoginCredential(username: username, password: password)
            return credential.isValid ? credential : LoginCredential.empty
        }
    }
}

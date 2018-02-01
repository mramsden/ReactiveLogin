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
    struct UserEventProvider {
        let usernameChanged: Observable<String?>
        let passwordChanged: Observable<String?>

        fileprivate func usernameObservable(defaultValue: String) -> Observable<String> {
            return usernameChanged.map { $0 ?? defaultValue }
        }

        fileprivate func passwordObservable(defaultValue: String) -> Observable<String> {
            return passwordChanged.map { $0 ?? defaultValue }
        }
    }

    let isValid: Observable<Bool>
    let credential: Observable<LoginCredential>

    init(userEventProvider: UserEventProvider) {
        isValid = Observable.concat(Observable.from(optional: false), LoginPresenter.isValidObservable(userEventProvider))
        credential = Observable.concat(Observable.from(optional: .empty), LoginPresenter.credentialObservable(userEventProvider))
    }

    private static func isValidObservable(_ eventProvider: UserEventProvider) -> Observable<Bool> {
        return Observable.zip(eventProvider.usernameObservable(defaultValue: ""), eventProvider.passwordObservable(defaultValue: "")) {
            let credential = LoginCredential(username: $0, password: $1)
            return credential.isValid
        }
    }

    private static func credentialObservable(_ eventProvider: UserEventProvider) -> Observable<LoginCredential> {
        return Observable.zip(eventProvider.usernameObservable(defaultValue: ""), eventProvider.passwordObservable(defaultValue: "")) {
            let credential = LoginCredential(username: $0, password: $1)
            return credential.isValid ? credential : LoginCredential.empty
        }
    }
}

//
// Copyright © 2018 Bitsden. All rights reserved.
//

@testable import ReactiveLogin
import RxSwift
import RxTest
import XCTest

class LoginCredentialTests: XCTestCase {
    func test_isValid_shouldBeFalseIfEitherUsernameOrPasswordAreEmpty() {
        let sut = LoginCredential(username: "", password: "")
        XCTAssertFalse(sut.isValid)
    }

    func test_equals_shouldBeFalse_whenUsernameOnLhsAndRhsAreDifferent() {
        let lhs = LoginCredential(username: "left", password: "")
        let rhs = LoginCredential(username: "right", password: "")
        XCTAssertNotEqual(lhs, rhs)
    }

    func test_equals_shouldBeFalse_whenPasswordOnLhsAndRhsAreDifferent() {
        let lhs = LoginCredential(username: "", password: "left")
        let rhs = LoginCredential(username: "", password: "right")
        XCTAssertNotEqual(lhs, rhs)
    }
}

class LoginPresenterTests: XCTestCase {
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        disposeBag = nil
        scheduler = nil
        super.tearDown()
    }

    func test_isValid_shouldStartAsFalse() {
        let sut = makeInitialLoginViewModel()

        let results = scheduler.createObserver(Bool.self)
        scheduler.scheduleAt(0) { [unowned self] in
            sut.isValid.subscribe(results).disposed(by: self.disposeBag)
        }
        scheduler.start()

        XCTAssertEqual(results.events.flatMap { $0.value.element }, [false])
    }

    func test_isValid_shouldBeFalse_whenUsernameAndPasswordAreBlank() {
        let sut = makeLoginViewModel()

        let results = scheduler.createObserver(Bool.self)
        scheduler.scheduleAt(0) { [unowned self] in
            sut.isValid.subscribe(results).disposed(by: self.disposeBag)
        }
        scheduler.start()

        XCTAssertEqual(results.events.last?.value.element, false)
    }

    func test_isValid_shouldBeTrue_whenUsernameAndPasswordAreNotBlank() {
        let sut = makeLoginViewModel(username: "username", password: "password")

        let results = scheduler.createObserver(Bool.self)
        scheduler.scheduleAt(0) { [unowned self] in
            sut.isValid.subscribe(results).disposed(by: self.disposeBag)
        }
        scheduler.start()

        XCTAssertEqual(results.events.last?.value.element, true)
    }

    func test_credential_shouldStartAsEmpty() {
        let sut = makeInitialLoginViewModel()

        let results = scheduler.createObserver(LoginCredential.self)
        scheduler.scheduleAt(0) { [unowned self] in
            sut.credential.subscribe(results).disposed(by: self.disposeBag)
        }
        scheduler.start()

        XCTAssertEqual(results.events.last?.value.element, .empty)
    }

    func test_credential_shouldBeCurrentUsernameAndPassword() {
        let sut = makeLoginViewModel(username: "username", password: "password")

        let results = scheduler.createObserver(LoginCredential.self)
        scheduler.scheduleAt(0) { [unowned self] in
            sut.credential.subscribe(results).disposed(by: self.disposeBag)
        }
        scheduler.start()

        XCTAssertEqual(results.events.last?.value.element, LoginCredential(username: "username", password: "password"))
    }

    func makeInitialLoginViewModel() -> LoginPresenter {
        return LoginPresenter(
            username: scheduler.createColdObservable([]).asObservable(),
            password: scheduler.createColdObservable([]).asObservable()
        )
    }

    func makeLoginViewModel(username: String = "", password: String = "") -> LoginPresenter {
        return LoginPresenter(
            username: scheduler.createColdObservable([next(0, username)]).asObservable(),
            password: scheduler.createColdObservable([next(0, password)]).asObservable()
        )
    }
}

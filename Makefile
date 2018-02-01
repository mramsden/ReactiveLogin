TEST_PLATFORM?=iOS Simulator
TEST_DEVICE_NAME?=iPhone 8

test_destination=platform=$(TEST_PLATFORM),name=$(TEST_DEVICE_NAME)
xcode_test=xcodebuild test -workspace ReactiveLogin.xcworkspace -scheme ReactiveLogin -destination '$(test_destination)'
xcpretty=bundle exec xcpretty

test: clean-test
	$(xcode_test) | $(xcpretty) -r junit -r html

test-ci: clean-test
	$(xcode_test)

clean-test:
	rm -rf build

setup:
	bundle install

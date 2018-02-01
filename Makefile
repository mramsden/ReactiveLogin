TEST_PLATFORM?=iOS Simulator
TEST_DEVICE_NAME?=iPhone 8

test_destination=platform=$(TEST_PLATFORM),name=$(TEST_DEVICE_NAME)
xcode_test=xcodebuild test \
	-derivedDataPath ./build/DerivedData \
	-workspace ReactiveLogin.xcworkspace \
	-scheme ReactiveLogin \
	-destination '$(test_destination)'
xcpretty=bundle exec xcpretty

test: clean-reports
	$(xcode_test) | $(xcpretty) -r junit -r html

test-ci:
	$(xcode_test) | $(xcpretty)

clean: clean-reports clean-derived-data

clean-reports:
	rm -rf build/reports

clean-derived-data:
	rm -rf build/DerivedData

setup:
	bundle install

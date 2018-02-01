TEST_PLATFORM?=iOS Simulator
TEST_DEVICE_NAME?=iPhone 8

test_destination=platform=$(TEST_PLATFORM),name=$(TEST_DEVICE_NAME)
xcode_test=xcodebuild test \
	-derivedDataPath ./build/DerivedData \
	-workspace ReactiveLogin.xcworkspace \
	-scheme ReactiveLogin \
	-destination '$(test_destination)' \
	-parallelizeTargets
xcode_archive=xcodebuild archive \
	-derivedDataPath ./build/DerivedData \
	-archivePath ./build/Archives/ReactiveLogin \
	-workspace ReactiveLogin.xcworkspace \
	-scheme ReactiveLogin \
	-configuration Release \
	-parallelizeTargets
xcpretty=bundle exec xcpretty -f ./teamcity_formatter.rb

test: clean-reports
	$(xcode_test) | $(xcpretty) -r junit -r html

test-ci:
	$(xcode_test) | $(xcpretty)

archive:
	$(xcode_archive) | $(xcpretty)

clean: clean-reports clean-derived-data clean-archives

clean-reports:
	rm -rf build/reports

clean-derived-data:
	rm -rf build/DerivedData

clean-archives:
	rm -rf build/Archives

setup:
	bundle install

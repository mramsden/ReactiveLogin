TEST_PLATFORM?=iOS Simulator
TEST_DEVICE_NAME?=iPhone 8

test_destination=platform=$(TEST_PLATFORM),name=$(TEST_DEVICE_NAME)

xcode_project=-workspace ReactiveLogin.xcworkspace \
	-scheme ReactiveLogin

xcode_build_for_test=xcodebuild build-for-testing \
	$(xcode_project) \
	-derivedDataPath ./build/DerivedData \
	-parallelizeTargets
xcode_test=xcodebuild test \
	$(xcode_project) \
	-derivedDataPath ./build/DerivedData \
	-destination '$(test_destination)' \
	-parallelizeTargets
xcode_archive=xcodebuild archive \
	$(xcode_project) \
	-derivedDataPath ./build/DerivedData \
	-archivePath ./build/Archives/ReactiveLogin \
	-configuration Release \
	-parallelizeTargets
xcpretty=bundle exec xcpretty -f ./teamcity_formatter.rb

test: clean-reports
	$(xcode_test) 2>&1 | $(xcpretty) -r junit -r html

test-ci:
	$(xcode_test) | $(xcpretty)

build-for-testing:
	$(xcode_build_for_test) | $(xcpretty)

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

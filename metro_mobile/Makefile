# local: auth thật ở backend trên máy. Demo offline: make run FLAVOR=dev
FLAVOR ?= local

.PHONY: gen test golden check-size analyze run run-device

gen:
	dart run build_runner build --delete-conflicting-outputs

test:
	flutter test --exclude-tags golden

golden:
	flutter test --tags golden --update-goldens

check-size:
	./tool/check_size.sh

analyze:
	flutter analyze

run:
	flutter run --dart-define-from-file=config/$(FLAVOR).json

# Máy thật cắm USB: chuyển localhost:8080 trên điện thoại về backend trên máy.
run-device:
	adb reverse tcp:8080 tcp:8080
	flutter run -d $$(adb get-serialno) --dart-define-from-file=config/device.json

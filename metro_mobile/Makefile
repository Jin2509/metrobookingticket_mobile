FLAVOR ?= dev

.PHONY: gen test golden check-size analyze run

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

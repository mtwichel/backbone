set -e

PROJECT_PATH="${1:-.}"
PROJECT_COVERAGE=${PROJECT_PATH}/coverage/lcov.info

rm -rf ./coverage
dart test --coverage=coverage
dart run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info --packages=.packages --report-on=lib
genhtml ${PROJECT_COVERAGE} -o coverage
open ./coverage/index.html
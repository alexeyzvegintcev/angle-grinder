#!/bin/bash

echo "### Running tests"

bower cache clean &&

cd script && ./jenkins-build-unit
# capture the results
RESULT=$?
if [$RESULT > 0]; then
  exit $RESULT
fi
cd ../grails/ag-plugin && ./gradlew test
# capture the results
RESULT=$?

if [$RESULT > 0]; then
  exit $RESULT
fi

echo "### Running publishing"

if [[ $TRAVIS_BRANCH == 'grails3' && $TRAVIS_PULL_REQUEST == 'false' ]]; then
	echo "### publishing plugin to bintray"
	#cd ../dao-plugin && ./gradlew bintrayUpload

else
  echo "TRAVIS_BRANCH: $TRAVIS_BRANCH"
  echo "TRAVIS_REPO_SLUG: $TRAVIS_REPO_SLUG"
  echo "TRAVIS_PULL_REQUEST: $TRAVIS_PULL_REQUEST"
fi

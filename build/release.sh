##Check for version
if [ -z $VERSION ]; then
  # If no version, get it from package.json
  VERSION=$(grep -Po '(?<="version": )"[0-9.]+",' package.json | grep -Po '[0-9.]+')
  if [ -z $VERSION ]; then
    echo "Environment VERSION is not set. You can set the version, eg. v0.0.2 to release"
    echo "Trying to get version from package.json, but version was not found?"
    exit 2
  fi

  # Check if version is free to be tagged
  NOTFREE=$(git tag -l | grep $VERSION)
  if [[ $NOTFREE ]]; then
    echo "Environment VERSION is not set. You can set the version, eg. v0.0.2 to release"
    echo "Trying to get version from package.json, but VERSION=$VERSION is already a used tag."
    exit 2
  fi
fi
test -z $VERSION && echo "Environment VERSION is not set. You must set the version, eg. v0.0.2 to release" && exit 1

git add --all
rv=$?
test $rv -ne $? && echo "git add --all failed "$rv && exit $rv
git commit
test $rv -ne $? && echo "git commit failed "$rv && exit $rv
git tag $VERSION
test $rv -ne $? && echo "git tag $VERSION failed "$rv && exit $rv
git push origin master --tags
test $rv -ne $? && echo "git push origin master failed "$rv && exit $rv


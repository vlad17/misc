#!/bin/bash
#
# Script run on the dev workstation to ship your repo
# to the remote build.

HELP_SCREEN="Options are:
    --debug            regular debug build*
    --release          regular release build*
    --tsan             debug build with thread sanitizer*
    --asan             debug build with address sanitizer*
    --ninja            use ninja instead of make
    --cmake            clean cmake files
    --clean            clean object files
    --git clean        clean git ignored files
    --clang            use clang compiler
    --no-compile-all   no compilation
    --no-test          no testing
    --help             show help screen

*build type specifications will require cmake file regeneration.
Additionally, tsan and asan flags will cause clang to be used.
These specifications override other flags.
"

TARGETS=
REMOTE_REF=refs/heads/test
for arg in "$@" ; do
  case $arg in
    --debug)
      REMOTE_REF=$REMOTE_REF%build_type=debug
      ;;
    --release)
      REMOTE_REF=$REMOTE_REF%build_type=release
      ;;
    --tsan)
      REMOTE_REF=$REMOTE_REF%build_type=tsan
      ;;
    --asan)
      REMOTE_REF=$REMOTE_REF%build_type=asan
      ;;
    --client)
      REMOTE_REF=$REMOTE_REF%build_type=client
      ;;
    --ninja)
      REMOTE_REF=$REMOTE_REF%builder=ninja
      ;;
    --cmake)
      REMOTE_REF=$REMOTE_REF%clean=cmake
      ;;
    --clean)
      REMOTE_REF=$REMOTE_REF%clean=make
      ;;
    --git-clean)
      REMOTE_REF=$REMOTE_REF%clean=git
      ;;
    --clang)
      REMOTE_REF=$REMOTE_REF%compiler=clang
      ;;
    --no-compile-all)
      REMOTE_REF=$REMOTE_REF%compile_all=false
      ;;
    --no-test)
      REMOTE_REF=$REMOTE_REF%test=false
      ;;
    --help)
      echo "$HELP_SCREEN"
      exit 0
      ;;
    --*)
      echo bad arg: $arg
      echo 'try \"remote-build.sh --help\" for a list of commands'
      exit 1
      ;;
    *)
      if [ -z "$TARGETS" ]; then
        TARGETS=$arg
      else
        TARGETS="$TARGETS;$arg"
      fi
      ;;
  esac
done

REMOTE_BUILD_REPO=$(git config remote-build.url)

if [ -z "$REMOTE_BUILD_REPO" ]; then
  echo No remote build repo configured.
  echo
  echo Please use 'git config remote-build.url ssh://host/path' to specify
  echo the repository where the remote build is setup. For example:
  echo   git config remote-build.url \\
  echo   ssh://c0328.halxg.cloudera.com/home/todd/autotest/
  exit 1
fi

set -e
set -o pipefail
COMMIT_ID=$(git stash create)

# In a non-dirty tree, it returns an empty string, so just push the current
# HEAD
if [ -z "$COMMIT_ID" ]; then
  COMMIT_ID=$(git rev-parse HEAD)
fi

if [ ! -z "$TARGETS" ]; then
  REMOTE_REF=$REMOTE_REF%targets=$TARGETS
fi

# Figure out the mapping from the remote repo path to the local
# one so that the output of the remote build can still be used in
# local emacs to jump to errors.
REMOTE_PATH=
LOCAL_PATH=
if [[ $REMOTE_BUILD_REPO =~ ssh://[^/]+(/.*) ]]; then
  REMOTE_PATH=${BASH_REMATCH[1]}
  LOCAL_PATH=$(cd ./$(git rev-parse --show-cdup) && pwd)/
  echo remote: $REMOTE_PATH local: $LOCAL_PATH
fi

# Delete the old test ref if it exists. Otherwise we can't re-build
# when it's already been built.
git push -f $REMOTE_BUILD_REPO :$REMOTE_REF 2>/dev/null || :

git push -f $REMOTE_BUILD_REPO $COMMIT_ID:$REMOTE_REF 2>&1 | perl -p -e "s,$REMOTE_PATH,$LOCAL_PATH,g"

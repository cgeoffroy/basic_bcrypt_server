#! /bin/bash -e

VERSION="$(jq -r '.PackageVersion' .goxc.json)"
BRANCHNAME="$(jq -r '.BranchName' .goxc.json)"
PRERELEASEINFO="$(jq -r '.PrereleaseInfo' .goxc.json)"
BUILDNAME="$(jq -r '.BuildName' .goxc.json)"
GH_USER="$(echo ${TRAVIS_REPO_SLUG} | cut -d '/' -f 1)"
GH_REPO="$(echo ${TRAVIS_REPO_SLUG} | cut -d '/' -f 2)"

NAME="v${VERSION}-${BRANCHNAME}.${PRERELEASEINFO}+b${BUILDNAME}"

env

#github-release release --user "${GH_USER}" --repo "${GH_REPO}" --tag "v${VERSION}" --name "${NAME}" --draft="true"

for F in $(find ${GOPATH}/bin/${GH_REPO}-xc/${VERSION}-* -type 'f' -name '*.tar.gz')
    echo "F=${F}"
done

#github-release upload --user "${GH_USER}" --repo "${GH_REPO}" --tag "v${VERSION}" --name "${NAME}" -f

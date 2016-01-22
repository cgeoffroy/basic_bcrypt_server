#! /bin/bash -e

VERSION="$(jq -r '.PackageVersion' .goxc.json)"
BRANCHNAME="$(jq -r '.BranchName' .goxc.json)"
PRERELEASEINFO="$(jq -r '.PrereleaseInfo' .goxc.json)"
BUILDNAME="$(jq -r '.BuildName' .goxc.json)"
GH_USER="$(echo ${TRAVIS_REPO_SLUG} | cut -d '/' -f 1)"
GH_REPO="$(echo ${TRAVIS_REPO_SLUG} | cut -d '/' -f 2)"

NAME="v${VERSION}-${BRANCHNAME}.${PRERELEASEINFO}+b${BUILDNAME}"

echo "VERSION=$VERSION"
echo "BRANCHNAME=$BRANCHNAME"
echo "PRERELEASEINFO=$PRERELEASEINFO"
echo "BUILDNAME=$BUILDNAME"
echo "GH_USER=$GH_USER"
echo "GH_REPO=$GH_REPO"
echo "NAME=$NAME"

#github-release release --user "${GH_USER}" --repo "${GH_REPO}" --tag "v${VERSION}" --name "${NAME}" --draft="true" --description "Built by Travis-ci.org"

for F in $(find ${GOPATH}/bin/${GH_REPO}-xc/${VERSION}-* -type 'f' -name '*.tar.gz'); do
    echo "F=${F}"
done

#github-release upload --user "${GH_USER}" --repo "${GH_REPO}" --tag "v${VERSION}" --name "${NAME}" -f

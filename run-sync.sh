#!/bin/bash

# Check out the source branch and run the portal build
pushd repos/openshift-docs
echo $BRANCH
git checkout $BRANCH || exit 1
python3 ../build_for_portal.py --product="$PRODUCT" --version=$VERSION --distro=$DISTRO --no-upstream-fetch

popd
# the subdirectory repos/openshift-docs/drupal-build now contains the new portal content

# Check out the target branch
pushd repos/layered-products-docs
git checkout $BRANCH
if [[ $? != 0 ]]; then
#  git checkout main || exit 1
  git checkout -b $BRANCH || exit 1
  git push -u origin $BRANCH || exit 1
fi
popd

# Preserve files (including directories) defined in keepnames
while read n ; do ./keepname-$KEEP.sh $n ; done <keepnames

cd repos/layered-products-docs

# Delete the content, note .git should not be affected
rm -rf *

# Copy over the new content

cp -R ../openshift-docs/drupal-build/$DISTRO/* .

# Create the README.md file
tee README.md << END
 # $PRODUCT

 Pantheon-ready docs mirrored from OpenShift docs repo to GitLab

 ## Sync details

 Docs synced on `date` from branch $BRANCH

 ## Adding a new docs set to sync

 Edit the sync.yaml file on the main branch of this GitLab repo.
END

# commit and push
git add .
git commit -m "Sync from GitHub, branch $BRANCH"
# a push retry was added because sometimes this specific push ends with a 504 gateway timeout code
git push || git push || exit 1

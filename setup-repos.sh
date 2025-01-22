rm -rf repos
mkdir repos
cd repos
if [ -z $1 ] ; then
  git clone git@gitlab.cee.redhat.com:red-hat-enterprise-openshift-documentation/layered-products-docs.git
else
# this option has a retry, because sometimes Gitlab fails with error 504
  git clone https://clone:"$1"@gitlab.cee.redhat.com/red-hat-enterprise-openshift-documentation/layered-products-docs.git || git clone https://clone:"$1"@gitlab.cee.redhat.com/red-hat-enterprise-openshift-documentation/layered-products-docs.git
fi
git clone https://github.com/openshift/openshift-docs.git --depth=1 --no-single-branch
cp openshift-docs/build_for_portal.py .

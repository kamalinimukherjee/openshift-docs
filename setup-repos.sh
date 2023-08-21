rm -rf repos
mkdir repos
cd repos
if [ -z $1 ] ; then
  git clone git@gitlab.cee.redhat.com:red-hat-enterprise-openshift-documentation/layered-products-docs.git
else
  git clone https://clone:"$1"@gitlab.cee.redhat.com/red-hat-enterprise-openshift-documentation/layered-products-docs.git
fi
git clone https://github.com/openshift/openshift-docs.git

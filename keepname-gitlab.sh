cd repos/layered-products-docs
echo "running keepname for $1"
find . -name "$1" -exec cp -R --parents {} ../openshift-docs/drupal-build/$DISTRO \;

cd repos/openshift-docs
echo "running keepname-github for $1"
find . -name docinfo.xml | grep -v drupal-build | xargs -I{} -n 1 cp -R --parents {} drupal-build/$DISTRO/

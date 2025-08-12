#!/usr/bin/python

# Read sync.yaml and produce sync.sh
import yaml
import sys

with open("sync.yaml") as fp:
    data = yaml.safe_load(fp)

products_array = data["products"]

with open("sync.sh", "w") as fp:
    fp.write("excode=0\n")
    for product_item in products_array:
        product = product_item["product"]
        distro = product_item["distro"]

        keep = "gitlab"
        try:
            if product_item["settings"]["keepfiles"] == "github":
                keep = "github"
        except KeyError: pass

        if product_item["branches"]==None:
            continue # "all branches commented out" is normal
        for branch in product_item["branches"]:
            version = "1.0"
            version_candidate = branch.split("-")[-1]
            if version_candidate[0].isnumeric():
                version = version_candidate

            if distro == "openshift-coo":
                version = "1-latest"

            fp.write(
                f'if PRODUCT="{product}" DISTRO="{distro}" BRANCH="{branch}" VERSION="{version}" KEEP="{keep}" ./run-sync.sh ; then\n'
            )
            fp.write(f'  echo succeeded: {branch}\n')
            fp.write('else\n')
            fp.write('  echo -e "${TXT_RED} failed:'+branch+'${TXT_CLEAR}"\n')
            fp.write('  excode=1\n')
            fp.write('fi\n')
    fp.write("exit $excode\n")

settings = data["settings"]
with open("keepnames","w") as kn:
    for fname in settings[0]["keepnames"]:
        kn.write(fname+"\n")

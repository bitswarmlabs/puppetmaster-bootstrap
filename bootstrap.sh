#!/bin/bash

provisioner="aws"
app_creator=$(whoami)
puppetversion=$(puppet --version)

DIR="$( cd "$( dirname "$${BASH_SOURCE[0]}" )" && pwd )"

echo "## Bootstrapping r10k"
FACTER_provisioner=$provisioner \
FACTER_puppetversion=puppetversion \
FACTER_app_project='puppetmaster' \
FACTER_app_creator=$app_creator \
puppet apply ${DIR}/manifests/r10k_bootstrap.pp \
    --show_diff \
    --verbose \
    --hiera_config_path=${DIR}/bootstrap/hiera.yaml
    --modulepath="${DIR}/modules:/etc/puppetlabs/code/modules:/opt/puppetlabs/puppet/modules"

echo "## Bootstrapping Puppetserver environments"
FACTER_provisioner=$provisioner \
FACTER_puppetversion=$puppetversion \
FACTER_app_project='puppetmaster' \
FACTER_app_creator=$app_creator \
puppet apply $${DIR}/environments/aws/manifests/base.pp \
    --show_diff \
    --verbose \
    --hiera_config_path=$${DIR}/bootstrap/hiera.yaml \
    --modulepath="${DIR}/modules:/etc/puppetlabs/code/modules:/opt/puppetlabs/puppet/modules"

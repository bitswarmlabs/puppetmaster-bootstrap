#!/bin/bash

provisioner=${1:-"aws"}
app_creator=${2:-`whoami`}
app_project=${3:-'puppetmaster'}
puppetversion=$(puppet --version)

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "## Bootstrapping r10k"
set -x

FACTER_provisioner=$provisioner \
FACTER_puppetversion=$puppetversion \
FACTER_app_project='puppetmaster' \
FACTER_app_creator=$app_creator \
puppet apply "${DIR}/manifests/r10k_bootstrap.pp" \
    --show_diff \
    --verbose \
    --hiera_config="${DIR}/hiera.yaml" \
    --modulepath="${DIR}/modules:/etc/puppetlabs/code/modules:/opt/puppetlabs/puppet/modules"

set +x

echo "## Bootstrapping Puppetserver environments"
set -x

FACTER_provisioner=$provisioner \
FACTER_puppetversion=$puppetversion \
FACTER_app_project='puppetmaster' \
FACTER_app_creator=$app_creator \
puppet apply "${DIR}/environments/aws/manifests/base.pp" \
    --show_diff \
    --verbose \
    --hiera_config="${DIR}/hiera.yaml" \
    --environment="production" \
    --modulepath="${DIR}/modules:/etc/puppetlabs/code/modules:/opt/puppetlabs/puppet/modules"

set +x

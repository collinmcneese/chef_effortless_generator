#!/bin/bash
# effortless-repo-gen.sh

# Used to create a new repository with the Chef Effortless Infrastructure template.
# Usage: effortless-repo-gen.sh -r repo_name [ -o habitat_origin_name ]
#         -r : repository name which will be created
#         -o : optional Chef Habitat origin name
#         -h : shows help and usage
#         -s : optional Chef Habitat scaffolding to use

usage()
{
  echo ""
  echo "${0} -- Used to create a new repository with the Chef Effortless Infrastructure template."
  echo "Usage: ${0} -r repo_name [ -o habitat_origin_name ]"
  echo -e "\t-r : repository name which will be created"
  echo -e "\t-o : optional Chef Habitat origin name"
  echo -e "\t-s : optional Chef Habitat scaffolding to use"
  echo -e "\t-h : shows help and usage"
}

itemCheck()
{
  local item="${1}"
  local type="${2}"
  if [ ! -${type} ${item} ]
  then
    echo "ERROR:: There was a problem detected, check log output."
    echo "ERROR:: Exiting."
    exit 1
  fi
}

############ Collect Arguments
while getopts "o:r:s:h" opt
do
  case ${opt} in
    o   ) haborigin=${OPTARG}      ;;
    r   ) reponame=${OPTARG}       ;;
    s   ) scaffolding=${OPTARG}    ;;
    h   ) usage ; exit 1     ;;
  esac
done

## Argument Checking
if [ -z "${reponame}" ];
then
  echo 'ERROR:: repo name must be specified'
  usage
  exit 1
fi

if [[ ${reponame} =~ [^[:alnum:]||_||-]+ ]] ;
then
  echo 'ERROR:: Bad Repo Name Specified'
  echo 'ERROR:: Name must be in aA-zZ_0-9 format and may include "_" or "-"'
  exit 1
fi

echo -e '\n### Building Chef Effortless repository location with the following options:'
echo -e "\t### REPO NAME   = ${reponame}"
if [[ ${haborigin} != '' ]]   ; then echo "### HAB ORIGIN      = ${haborigin}" ; fi
if [[ ${scaffolding} != '' ]] ; then echo "### HAB SCAFFOLDING = ${scaffolding}" ; fi

############ Build Directory Structure
if [ -d ${reponame} ];
then
  echo "ERROR:: Repo name specified, ${reponame}, already exists!!"
  echo "ERROR:: Repo directory must not exist, exiting."
  exit 1
fi

repodir="$(pwd)/${reponame}"

echo "### Building Repository Structure ${reponame}"

for folder in cookbooks policyfiles; do
  mkdir -p "${repodir}/${folder}"
done

itemCheck ${repodir} d
echo "### Created ${repodir}"

############ Seed template cookbook
echo "### Creating cookbook"

cd ${repodir}/cookbooks
chef generate cookbook ${reponame}

itemCheck ${repodir}/cookbooks/${reponame} d
echo "### Created cookbook ${repodir}/cookbooks/${reponame}"

############ Seed Policyfile
echo "### Creating Policyfile for Habitat package"

cd ${repodir}/policyfiles
chef generate policyfile

itemCheck ${repodir}/policyfiles/Policyfile.rb f
ls -l
echo "### Created Policyfile for Habitat package"

############ Seed Chef Habitat plan
echo "### Creating Chef Habitat plan for ${reponame}"

## Pass arguments if they were specified.
habopt=''
if [ ${haborigin} ]
then
  habopt+="-o ${haborigin}"
fi
if [ ${scaffolding} ]
then
  habopt+="-s ${scaffolding}"
fi

cd ${repodir}
hab plan init ${habopt}

itemCheck ${repodir}/habitat/plan.sh f
echo "### Created Chef Habitat plan"

############ Initialize Git
echo "### Initializing git for repository"

cd ${repodir}
echo -e "# ${reponame} Chef Infra Effortless package\n\nTODO: Build a descriptive README for this package." > README.md
git init .

itemCheck ${repodir}/.git d

############ Complete
echo "### Completed building repository:"
echo "### ${repodir}"
ls -l ${repodir}

# Overview

Chef Infra generator used to create [Effortless Infrastructure](<chef.io/products/effortless-infrastructure/>) repositories with Chef Infra cookbook and Habitat package configurations.

## Requirements

* `Chef Workstation` - Usage of this generator is only for `Chef Workstation` and will not work with `ChefDK`.
* `Chef Habitat` - Chef Habitat <https://www.habitat.sh/docs/install-habitat/> must be installed locally with `hab` executable existing in user PATH.

## Usage

* `effortless-repo-gen.sh`
* `effortless-repo-gen.ps1`
* `HAB_ORIGIN`

```plain
 ./effortless-repo-gen.sh -r effortless_repo

effortless_repo
├── README.md
├── cookbooks
│   └── effortless_repo
│       ├── CHANGELOG.md
│       ├── LICENSE
│       ├── Policyfile.rb
│       ├── README.md
│       ├── chefignore
│       ├── kitchen.yml
│       ├── metadata.rb
│       ├── recipes
│       │   └── default.rb
│       ├── spec
│       │   ├── spec_helper.rb
│       │   └── unit
│       │       └── recipes
│       │           └── default_spec.rb
│       └── test
│           └── integration
│               └── default
│                   └── default_test.rb
├── habitat
│   ├── README.md
│   ├── config
│   ├── default.toml
│   ├── hooks
│   └── plan.sh
└── policyfiles
    └── Policyfile.rb
```

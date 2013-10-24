## Run SWI-Prolog on dotCloud

[dotCloud](https://www.dotcloud.com) is a PaaS provider.  This repository provides support for running SWI-Prolog on their platform.

## Usage

Instructions for using SWI-Prolog on dotCloud:

  * Create a dotCloud application (if you haven't already)
  * In the application's root directory:
  * `git submodule add https://github.com/mndrix/swi-prolog-on-dotcloud`
  * Copy the custom service snippet from `swi-prolog-on-dotcloud/dotcloud.yml` into your application's `dotcloud.yml` file
  * Configure the service's `approot` if necessary
  * Create a `run` script which launches your application

For an example showing the final product, see this [hello world](https://github.com/mndrix/helloswipl-dotcloud) sample application.

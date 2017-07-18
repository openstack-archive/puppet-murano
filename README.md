Team and repository tags
========================

[![Team and repository tags](http://governance.openstack.org/badges/puppet-murano.svg)](http://governance.openstack.org/reference/tags/index.html)

<!-- Change things from this point on -->

murano
======

#### Table of Contents

1. [Overview - What is the murano module?](#overview)
2. [Module Description - What does the module do?](#module-description)
3. [Setup - The basics of getting started with murano](#setup)
4. [Implementation - An under-the-hood peek at what the module is doing](#implementation)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)
7. [Contributors - Those with commits](#contributors)
8. [Release Notes - Notes on the most recent updates to the module](#release-notes)

Overview
--------

The Murano module is a part of [OpenStack](https://github.com/openstack), an effort by the OpenStack infrastructure team to provide continuous integration testing and code review for OpenStack and OpenStack community projects as part of the core software. The module itself is used to flexibly configure and manage the application catalog service for OpenStack.

Module Description
------------------

The murano module is an attempt to make Puppet capable of managing the
entirety of murano.

Setup
-----

**What the murano module affects:**

* [Murano](https://wiki.openstack.org/wiki/Murano), the application catalog service for OpenStack.

### Installing murano

    puppet module install openstack/murano

### Beginning with murano

To use the murano module's functionality you will need to declare multiple
resources.  This is not an exhaustive list of all the components needed; we
recommend you consult and understand the
[core of openstack](http://docs.openstack.org) documentation.

Implementation
--------------

### murano

puppet-murano is a combination of Puppet manifests and ruby code to deliver
configuration and extra functionality through types and providers.

Limitations
-----------

None.

Beaker-Rspec
------------

This module has beaker-rspec tests

To run:

```shell
bundle install
bundle exec rspec spec/acceptance
```

Development
-----------

Developer documentation for the entire puppet-openstack project.

* https://docs.openstack.org/puppet-openstack-guide/latest/

Contributors
------------
The github [contributor graph](https://github.com/openstack/puppet-murano/graphs/contributors).

Release Notes
-------------

**1.0.0**

* Initial

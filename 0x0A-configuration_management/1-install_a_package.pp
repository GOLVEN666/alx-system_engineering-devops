#!/usr/bin/pup
#   This is a Puppet script that installs the Flask Python package
package {'flask':
  ensure   => '2.1.0',
  provider => 'pip3'
}

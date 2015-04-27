#
# Top-level variables
#
# There must not be any whitespace between this comment and the variables or
# in between any two variables in order for them to be correctly parsed and
# passed around in test.sh
#

#
# Default: should at least behave like an openstack server
#
node default {
  class { 'openstack_project::server':
    sysadmins => hiera('sysadmins', []),
  }
}

#
# Long lived servers:
#
node 'gerrit.rcarrillocruz.net' {
  class { 'openstack_project::review':
    project_config_repo             => 'https://git.openstack.org/openstack-infra/project-config',
    ssl_cert_file                   => '/etc/ssl/certs/ssl-cert-snakeoil.pem',
    ssl_key_file                    => '/etc/ssl/private/ssl-cert-snakeoil.key',
    ssl_chain_file                  => '',
#    github_oauth_token              => hiera('gerrit_github_token', 'XXX'),
#    github_project_username         => hiera('github_project_username', 'username'),
#    github_project_password         => hiera('github_project_password', 'XXX'),
    mysql_host                      => hiera('gerrit_mysql_host', 'localhost'),
    mysql_password                  => hiera('gerrit_mysql_password', 'XXX'),
    email_private_key               => hiera('gerrit_email_private_key', 'XXX'),
    contactstore                    => false,
#    contactstore_appsec             => hiera('gerrit_contactstore_appsec', 'XXX'),
#    contactstore_pubkey             => hiera('gerrit_contactstore_pubkey', 'XXX'),
    ssh_rsa_key_contents            => hiera('gerrit_ssh_rsa_key_contents', 'XXX'),
    ssh_rsa_pubkey_contents         => hiera('gerrit_ssh_rsa_pubkey_contents', 'XXX'),
    ssh_project_rsa_key_contents    => hiera('gerrit_project_ssh_rsa_key_contents', 'XXX'),
    ssh_project_rsa_pubkey_contents => hiera('gerrit_project_ssh_rsa_pubkey_contents', 'XXX'),
#    lp_sync_consumer_key            => hiera('gerrit_lp_consumer_key', 'XXX'),
#    lp_sync_token                   => hiera('gerrit_lp_access_token', 'XXX'),
#    lp_sync_secret                  => hiera('gerrit_lp_access_secret', 'XXX'),
    sysadmins                       => hiera('sysadmins', []),
  }
}

node 'jenkins.rcarrillocruz.net' {
  $group = "jenkins"
  class { 'openstack_project::jenkins':
    project_config_repo     => 'https://git.openstack.org/openstack-infra/project-config',
    jenkins_jobs_password   => hiera('jenkins_jobs_password', 'XXX'),
    jenkins_ssh_private_key => hiera('jenkins_ssh_private_key_contents', 'XXX'),
    ssl_cert_file           => '/etc/ssl/certs/ssl-cert-snakeoil.pem',
    ssl_key_file            => '/etc/ssl/private/ssl-cert-snakeoil.key',
    ssl_chain_file          => '',
    sysadmins               => hiera('sysadmins', []),
    zmq_event_receivers     => ['nodepool.rcarrillocruz.net'],
  }
}

node 'puppetmaster.rcarrillocruz.net' {
  class { 'openstack_project::puppetmaster':
    root_rsa_key        => hiera('puppetmaster_root_rsa_key', 'XXX'),
    sysadmins           => hiera('sysadmins', []),
    version             => '3.6.',
    puppetmaster_server => 'puppetmaster.rcarrillocruz.net',
    puppetdb            => false,
  }
}

node 'puppetdb.openstack.org' {
  class { 'openstack_project::puppetdb':
    sysadmins => hiera('sysadmins', []),
  }
}

node 'nodepool.openstack.org' {
  class { 'openstack_project::nodepool_prod':
    project_config_repo      => 'https://git.openstack.org/openstack-infra/project-config',
    mysql_password           => hiera('nodepool_mysql_password', 'XXX'),
    mysql_root_password      => hiera('nodepool_mysql_root_password', 'XXX'),
    nodepool_ssh_private_key => hiera('jenkins_ssh_private_key_contents', 'XXX'),
    sysadmins                => hiera('sysadmins', []),
    statsd_host              => 'graphite.openstack.org',
    jenkins_api_user         => hiera('jenkins_api_user', 'username'),
    jenkins_api_key          => hiera('jenkins_api_key', 'XXX'),
    jenkins_credentials_id   => hiera('jenkins_credentials_id', 'XXX'),
    rackspace_username       => hiera('nodepool_rackspace_username', 'username'),
    rackspace_password       => hiera('nodepool_rackspace_password', 'XXX'),
    rackspace_project        => hiera('nodepool_rackspace_project', 'project'),
    hpcloud_username         => hiera('nodepool_hpcloud_username', 'username'),
    hpcloud_password         => hiera('nodepool_hpcloud_password', 'XXX'),
    hpcloud_project          => hiera('nodepool_hpcloud_project', 'project'),
    tripleo_username         => hiera('nodepool_tripleo_username', 'username'),
    tripleo_password         => hiera('nodepool_tripleo_password', 'XXX'),
    tripleo_project          => hiera('nodepool_tripleo_project', 'project'),
  }
}

node /^zm\d+\.openstack\.org$/ {
  $group = "zuul-merger"
  class { 'openstack_project::zuul_merger':
    gearman_server       => 'zuul.openstack.org',
    gerrit_server        => 'review.openstack.org',
    gerrit_user          => 'jenkins',
    gerrit_ssh_host_key  => hiera('gerrit_ssh_rsa_pubkey_contents', 'XXX'),
    zuul_ssh_private_key => hiera('zuul_ssh_private_key_contents', 'XXX'),
    sysadmins            => hiera('sysadmins', []),
  }
}

node 'zuul.rcarrillocruz.net' {
  class { 'openstack_project::zuul_prod':
    project_config_repo  => 'https://git.openstack.org/openstack-infra/project-config',
    gerrit_server        => 'gerrit.rcarrillocruz.net ',
    gerrit_user          => 'jenkins',
    gerrit_ssh_host_key  => hiera('gerrit_ssh_rsa_pubkey_contents', 'XXX'),
    zuul_ssh_private_key => hiera('zuul_ssh_private_key_contents', 'XXX'),
    url_pattern          => 'http://logs.openstack.org/{build.parameters[LOG_PATH]}',
    zuul_url             => 'http://zuul.rcarrillocruz.net/p',
    sysadmins            => hiera('sysadmins', []),
    statsd_host          => '',
    gearman_workers      => [
      'jenkins.rcarrillocruz.net',
    ],
  }
}

# vim:sw=2:ts=2:expandtab:textwidth=79

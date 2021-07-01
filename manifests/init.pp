# @summary Provision Terragrunt
#
# Provisions Terragrunt
#
# @example
#   include terragrunt
class terragrunt (
  String $version = 'latest',
  ) {
    file { '/tmp/install_terragrunt.sh':
      ensure  => present,
      mode    => '0744',
      content => file('terragrunt/install_terragrunt.sh'),
    }

    exec { 'install_terragrunt.sh':
      command   => "/tmp/install_terragrunt.sh ${version}",
      cwd       => '/tmp',
      path      => '/usr/local/sbin:/usr/local/bin:/usr/bin:/usr/sbin:/bin:/sbin',
      #path      => $path,
      #provider  => 'shell',
      logoutput => true,
    }
}

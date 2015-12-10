require 'spec_helper'

describe 'murano::dashboard' do

  let :facts do {
    :osfamily       => 'Debian',
  } end

  shared_examples_for 'with default class parameters' do
    it { is_expected.to contain_package('murano-dashboard').with({
      :ensure => 'present',
      :name   => 'python-murano-dashboard',
    })}

    it { is_expected.to contain_concat('/etc/openstack-dashboard/local_settings.py')}
    it { is_expected.to contain_concat__fragment('original_config').with({
      :target => '/etc/openstack-dashboard/local_settings.py',
      :source => '/etc/openstack-dashboard/local_settings.py',
      :order  => 1,
    })}

    it { is_expected.to contain_concat__fragment('murano_dashboard_section').with({
      :target => '/etc/openstack-dashboard/local_settings.py',
      :order  => 2,
    })}

    it { is_expected.to_not contain_concat__fragment('murano_dashboard_section').with_content(/MURANO_API_URL = /)}
    it { is_expected.to_not contain_concat__fragment('murano_dashboard_section').with_content(/MURANO_REPO_URL = /)}
    it { is_expected.to contain_concat__fragment('murano_dashboard_section').with_content(/MAX_FILE_SIZE_MB = '5'/)}
    it { is_expected.to contain_concat__fragment('murano_dashboard_section').with_content(/METADATA_CACHE_DIR = '\/var\/cache\/murano-dashboard'/)}
    it { is_expected.to contain_concat__fragment('murano_dashboard_section').with_content(/LOGGING\['loggers'\]\['muranodashboard'\] = \{'handlers': \['syslog'\], 'level': 'DEBUG'\}/)}
    it { is_expected.to contain_concat__fragment('murano_dashboard_section').with_content(/LOGGING\['loggers'\]\['muranoclient'\] = \{'handlers': \['syslog'\], 'level': 'ERROR'\}/)}

    it { is_expected.to contain_exec('clean_horizon_config').with({
      :command => 'sed -e \'/^## MURANO_CONFIG_BEGIN/,/^## MURANO_CONFIG_END ##/ d\' -i /etc/openstack-dashboard/local_settings.py',
      :onlyif  => 'grep \'^## MURANO_CONFIG_BEGIN\' /etc/openstack-dashboard/local_settings.py',
    })}

    it { is_expected.to contain_exec('django_collectstatic').with({
      :command => '/usr/share/openstack-dashboard/manage.py collectstatic --noinput --clear'
    })}

    it { is_expected.to contain_exec('django_compressstatic').with({
      :command => '/usr/share/openstack-dashboard/manage.py compress --force'
    })}

    it { is_expected.to contain_exec('django_syncdb').with({
      :command => '/usr/share/openstack-dashboard/manage.py syncdb --noinput'
    })}
  end

  shared_examples_for 'with parameters override' do
    let :params do {
      :api_url               => 'http://127.0.0.1:8083',
      :repo_url              => 'http://storage.apps.openstack.com',
      :collect_static_script => '/bin/openstack-dashboard/manage.py',
      :metadata_dir          => '/tmp/muranodashboard-cache',
      :max_file_size         => '5',
    }
    end

    it { is_expected.to contain_package('murano-dashboard').with({
      :ensure => 'present',
      :name   => 'python-murano-dashboard',
    })}

    it { is_expected.to contain_concat('/etc/openstack-dashboard/local_settings.py')}
    it { is_expected.to contain_concat__fragment('original_config').with({
      :target => '/etc/openstack-dashboard/local_settings.py',
      :source => '/etc/openstack-dashboard/local_settings.py',
      :order  => 1,
    })}

    it { is_expected.to contain_concat__fragment('murano_dashboard_section').with({
      :target => '/etc/openstack-dashboard/local_settings.py',
      :order  => 2,
    })}

    it { is_expected.to contain_concat__fragment('murano_dashboard_section').with_content(/MURANO_API_URL = 'http:\/\/127.0.0.1:8083'/)}
    it { is_expected.to contain_concat__fragment('murano_dashboard_section').with_content(/MURANO_REPO_URL = 'http:\/\/storage.apps.openstack.com'/)}
    it { is_expected.to contain_concat__fragment('murano_dashboard_section').with_content(/MAX_FILE_SIZE_MB = '5'/)}
    it { is_expected.to contain_concat__fragment('murano_dashboard_section').with_content(/METADATA_CACHE_DIR = '\/tmp\/muranodashboard-cache'/)}
    it { is_expected.to contain_concat__fragment('murano_dashboard_section').with_content(/LOGGING\['loggers'\]\['muranodashboard'\] = \{'handlers': \['syslog'\], 'level': 'DEBUG'\}/)}
    it { is_expected.to contain_concat__fragment('murano_dashboard_section').with_content(/LOGGING\['loggers'\]\['muranoclient'\] = \{'handlers': \['syslog'\], 'level': 'ERROR'\}/)}

    it { is_expected.to contain_exec('clean_horizon_config').with({
      :command => 'sed -e \'/^## MURANO_CONFIG_BEGIN/,/^## MURANO_CONFIG_END ##/ d\' -i /etc/openstack-dashboard/local_settings.py',
      :onlyif  => 'grep \'^## MURANO_CONFIG_BEGIN\' /etc/openstack-dashboard/local_settings.py',
    })}

    it { is_expected.to contain_exec('django_collectstatic').with({
      :command => '/bin/openstack-dashboard/manage.py collectstatic --noinput --clear'
    })}

    it { is_expected.to contain_exec('django_compressstatic').with({
      :command => '/bin/openstack-dashboard/manage.py compress --force'
    })}

    it { is_expected.to contain_exec('django_syncdb').with({
      :command => '/bin/openstack-dashboard/manage.py syncdb --noinput'
    })}
  end

  context 'on Debian platforms' do
    let :facts do
      {
        :osfamily => 'Debian',
        :operatingsystem => 'Debian',
        :concat_basedir => '/var/lib/puppet/concat'
      }
    end

    it_configures 'with default class parameters'
    it_configures 'with parameters override'
  end
end

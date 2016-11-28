require 'spec_helper'

describe 'murano::dashboard' do

  let :params do
    {
    }
  end

  let :dashboard_params do {
    :dashboard_name        => 'Application Catalog',
    :repo_url              => 'http://storage.apps.openstack.com',
    :enable_glare          => true,
    :collect_static_script => '/bin/openstack-dashboard/manage.py',
    :metadata_dir          => '/tmp/muranodashboard-cache',
    :max_file_size         => '5',
    :sync_db               => false,
    :log_handler           => 'console',
  }
  end

  shared_examples_for 'murano dashboard' do
    context 'with basic dashboard options and default settings' do
      it_configures 'with default class parameters'
    end

    context 'with non-default settings' do
      before { params.merge!( dashboard_params ) }
      it_configures 'with parameters override'
    end
  end

  shared_examples 'with default class parameters' do


    let(:collect_static_command) {
      if facts[:os_package_type] == 'ubuntu'
        "/usr/share/openstack-dashboard/manage.py collectstatic --noinput"
      else
        "/usr/share/openstack-dashboard/manage.py collectstatic --noinput --clear"
      end
    }

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
    it { is_expected.to_not contain_concat__fragment('murano_dashboard_section').with_content(/MURANO_DASHBOARD_NAME = /)}
    it { is_expected.to contain_concat__fragment('murano_dashboard_section').with_content(/MAX_FILE_SIZE_MB = '5'/)}
    it { is_expected.to contain_concat__fragment('murano_dashboard_section').with_content(/METADATA_CACHE_DIR = '\/var\/cache\/murano-dashboard'/)}
    it { is_expected.to contain_concat__fragment('murano_dashboard_section').with_content(/LOGGING\['loggers'\]\['muranodashboard'\] = \{'handlers': 'file', 'level': 'DEBUG'\}/)}
    it { is_expected.to contain_concat__fragment('murano_dashboard_section').with_content(/LOGGING\['loggers'\]\['muranoclient'\] = \{'handlers': 'file', 'level': 'ERROR'\}/)}
    it { is_expected.to contain_concat__fragment('murano_dashboard_section').with_content(/MURANO_USE_GLARE = False/)}

    it { is_expected.to contain_exec('clean_horizon_config').with({
      :command => 'sed -e \'/^## MURANO_CONFIG_BEGIN/,/^## MURANO_CONFIG_END ##/ d\' -i /etc/openstack-dashboard/local_settings.py',
      :onlyif  => 'grep \'^## MURANO_CONFIG_BEGIN\' /etc/openstack-dashboard/local_settings.py',
    })}

    it { is_expected.to contain_exec('django_collectstatic').with({
      :command => collect_static_command
    })}

    it { is_expected.to contain_exec('django_compressstatic').with({
      :command => '/usr/share/openstack-dashboard/manage.py compress --force'
    })}

    it { is_expected.to contain_exec('django_syncdb').with({
      :command => '/usr/share/openstack-dashboard/manage.py migrate --noinput'
    })}
  end

  shared_examples 'with parameters override' do

    let(:collect_static_command) {
      if facts[:os_package_type] == 'ubuntu'
        "/bin/openstack-dashboard/manage.py collectstatic --noinput"
      else
        "/bin/openstack-dashboard/manage.py collectstatic --noinput --clear"
      end
    }

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

    it { is_expected.to contain_concat__fragment('murano_dashboard_section').with_content(/MURANO_DASHBOARD_NAME = 'Application Catalog'/)}
    it { is_expected.to contain_concat__fragment('murano_dashboard_section').with_content(/MURANO_REPO_URL = 'http:\/\/storage.apps.openstack.com'/)}
    it { is_expected.to contain_concat__fragment('murano_dashboard_section').with_content(/MAX_FILE_SIZE_MB = '5'/)}
    it { is_expected.to contain_concat__fragment('murano_dashboard_section').with_content(/METADATA_CACHE_DIR = '\/tmp\/muranodashboard-cache'/)}
    it { is_expected.to contain_concat__fragment('murano_dashboard_section').with_content(/LOGGING\['loggers'\]\['muranodashboard'\] = \{'handlers': 'console', 'level': 'DEBUG'\}/)}
    it { is_expected.to contain_concat__fragment('murano_dashboard_section').with_content(/LOGGING\['loggers'\]\['muranoclient'\] = \{'handlers': 'console', 'level': 'ERROR'\}/)}
    it { is_expected.to contain_concat__fragment('murano_dashboard_section').with_content(/MURANO_USE_GLARE = True/)}

    it { is_expected.to contain_exec('clean_horizon_config').with({
      :command => 'sed -e \'/^## MURANO_CONFIG_BEGIN/,/^## MURANO_CONFIG_END ##/ d\' -i /etc/openstack-dashboard/local_settings.py',
      :onlyif  => 'grep \'^## MURANO_CONFIG_BEGIN\' /etc/openstack-dashboard/local_settings.py',
    })}

    it { is_expected.to contain_exec('django_collectstatic').with({
      :command => collect_static_command
    })}

    it { is_expected.to contain_exec('django_compressstatic').with({
      :command => '/bin/openstack-dashboard/manage.py compress --force'
    })}

    it { is_expected.to_not contain_exec('django_syncdb').with({
      :command => '/bin/openstack-dashboard/manage.py syncdb --noinput'
    })}
  end

  context 'on Debian platforms' do
    let :facts do
      OSDefaults.get_facts({
        :osfamily        => 'Debian',
        :operatingsystem => 'Debian',
        :concat_basedir  => '/var/lib/puppet/concat',
      })
    end

    it_behaves_like 'murano dashboard'
  end
end

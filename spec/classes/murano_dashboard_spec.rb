require 'spec_helper'

describe 'murano::dashboard' do
  let :params do
    {}
  end

  let :dashboard_params do
    {
      :dashboard_name          => 'Application Catalog',
      :repo_url                => 'http://storage.apps.openstack.com',
      :enable_glare            => true,
      :collect_static_script   => '/bin/openstack-dashboard/manage.py',
      :metadata_dir            => '/tmp/muranodashboard-cache',
      :max_file_size           => '5',
      :sync_db                 => false,
      :log_handler             => 'console',
      :image_filter_project_id => '00000000-0000-0000-0000-000000000000',
    }
    end

  shared_examples 'murano::dashboard' do
    context 'with basic dashboard options and default settings' do
      it_behaves_like 'with default class parameters'
    end

    context 'with non-default settings' do
      before { params.merge!( dashboard_params ) }
      it_behaves_like 'with parameters override'
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

    it { should contain_package('murano-dashboard').with({
      :ensure => 'present',
      :name   => platform_params[:dashboard_package_name],
    })}

    it { should contain_concat(platform_params[:dashboard_config])}
    it { should contain_concat__fragment('original_config').with({
      :target => platform_params[:dashboard_config],
      :source => platform_params[:dashboard_config],
      :order  => 1,
    })}

    it { should contain_concat__fragment('murano_dashboard_section').with({
      :target => platform_params[:dashboard_config],
      :order  => 2,
    })}

    it { should_not contain_concat__fragment('murano_dashboard_section').with_content(/MURANO_API_URL = /)}
    it { should_not contain_concat__fragment('murano_dashboard_section').with_content(/MURANO_REPO_URL = /)}
    it { should_not contain_concat__fragment('murano_dashboard_section').with_content(/MURANO_DASHBOARD_NAME = /)}
    it { should_not contain_concat__fragment('murano_dashboard_section').with_content(/MURANO_IMAGE_FILTER_PROJECT_ID = /)}
    it { should contain_concat__fragment('murano_dashboard_section').with_content(/MAX_FILE_SIZE_MB = '5'/)}
    it { should contain_concat__fragment('murano_dashboard_section').with_content(/METADATA_CACHE_DIR = '\/var\/cache\/murano-dashboard'/)}
    it { should contain_concat__fragment('murano_dashboard_section').with_content(/LOGGING\['loggers'\]\['muranodashboard'\] = \{'handlers': 'file', 'level': 'DEBUG'\}/)}
    it { should contain_concat__fragment('murano_dashboard_section').with_content(/LOGGING\['loggers'\]\['muranoclient'\] = \{'handlers': 'file', 'level': 'ERROR'\}/)}
    it { should contain_concat__fragment('murano_dashboard_section').with_content(/MURANO_USE_GLARE = False/)}

    it { should contain_exec('clean_horizon_config').with({
      :command => "sed -e \'/^## MURANO_CONFIG_BEGIN/,/^## MURANO_CONFIG_END ##/ d\' -i #{platform_params[:dashboard_config]}",
      :onlyif  => "grep \'^## MURANO_CONFIG_BEGIN\' #{platform_params[:dashboard_config]}",
    })}

    it { should contain_exec('django_collectstatic').with({
      :command => collect_static_command
    })}

    it { should contain_exec('django_compressstatic').with({
      :command => '/usr/share/openstack-dashboard/manage.py compress --force'
    })}

    it { should contain_exec('django_syncdb').with({
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

    it { should contain_package('murano-dashboard').with({
      :ensure => 'present',
      :name   => platform_params[:dashboard_package_name],
    })}

    it { should contain_concat(platform_params[:dashboard_config])}
    it { should contain_concat__fragment('original_config').with({
      :target => platform_params[:dashboard_config],
      :source => platform_params[:dashboard_config],
      :order  => 1,
    })}

    it { should contain_concat__fragment('murano_dashboard_section').with({
      :target => platform_params[:dashboard_config],
      :order  => 2,
    })}

    it { should contain_concat__fragment('murano_dashboard_section').with_content(/MURANO_DASHBOARD_NAME = 'Application Catalog'/)}
    it { should contain_concat__fragment('murano_dashboard_section').with_content(/MURANO_REPO_URL = 'http:\/\/storage.apps.openstack.com'/)}
    it { should contain_concat__fragment('murano_dashboard_section').with_content(/MAX_FILE_SIZE_MB = '5'/)}
    it { should contain_concat__fragment('murano_dashboard_section').with_content(/METADATA_CACHE_DIR = '\/tmp\/muranodashboard-cache'/)}
    it { should contain_concat__fragment('murano_dashboard_section').with_content(/LOGGING\['loggers'\]\['muranodashboard'\] = \{'handlers': 'console', 'level': 'DEBUG'\}/)}
    it { should contain_concat__fragment('murano_dashboard_section').with_content(/LOGGING\['loggers'\]\['muranoclient'\] = \{'handlers': 'console', 'level': 'ERROR'\}/)}
    it { should contain_concat__fragment('murano_dashboard_section').with_content(/MURANO_USE_GLARE = True/)}
    it { should contain_concat__fragment('murano_dashboard_section').with_content(/MURANO_IMAGE_FILTER_PROJECT_ID = '00000000-0000-0000-0000-000000000000'/)}

    it { should contain_exec('clean_horizon_config').with({
      :command => "sed -e \'/^## MURANO_CONFIG_BEGIN/,/^## MURANO_CONFIG_END ##/ d\' -i #{platform_params[:dashboard_config]}",
      :onlyif  => "grep \'^## MURANO_CONFIG_BEGIN\' #{platform_params[:dashboard_config]}",
    })}

    it { should contain_exec('django_collectstatic').with({
      :command => collect_static_command
    })}

    it { should contain_exec('django_compressstatic').with({
      :command => '/bin/openstack-dashboard/manage.py compress --force'
    })}

    it { should_not contain_exec('django_syncdb').with({
      :command => '/bin/openstack-dashboard/manage.py syncdb --noinput'
    })}
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts({
          :concat_basedir  => '/var/lib/puppet/concat',
        }))
      end

      let (:platform_params) do
        case facts[:osfamily]
        when 'Debian'
          {
            :dashboard_package_name => 'python3-murano-dashboard',
            :dashboard_config       => '/etc/openstack-dashboard/local_settings.py'
          }
        when 'RedHat'
          {
            :dashboard_package_name => 'openstack-murano-ui',
            :dashboard_config       => '/etc/openstack-dashboard/local_settings'
          }
        end
      end

      it_behaves_like 'murano::dashboard'
    end
  end
end

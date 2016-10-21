require 'spec_helper'

describe 'collectd::plugin::interface', type: :class do
  let :facts do
    {
      osfamily: 'RedHat',
      collectd_version: '4.8.0',
      operatingsystemmajrelease: '7'
    }
  end

  context ':ensure => present and :interfaces => [\'eth0\']' do
    let :params do
      { interfaces: ['eth0'] }
    end
    it 'Will create /etc/collectd.d/10-interface.conf' do
      should contain_file('interface.load').with(ensure: 'present',
                                                 path: '/etc/collectd.d/10-interface.conf',
                                                 content: %r{Interface  "eth0"})
    end
  end

  context ':ensure => absent' do
    let :params do
      { interfaces: ['eth0'], ensure: 'absent' }
    end
    it 'Will not create /etc/collectd.d/10-interface.conf' do
      should contain_file('interface.load').with(ensure: 'absent',
                                                 path: '/etc/collectd.d/10-interface.conf')
    end
  end

  context ':interfaces is not an array' do
    let :params do
      { interfaces: 'eth0' }
    end
    it 'Will raise an error about :interfaces being a String' do
      should compile.and_raise_error(%r{String})
    end
  end

  context 'interface options should be set with collectd 5.6' do
    let :facts do
      {
        collectd_version: '5.6',
      }
    end
    let :params do
      {
        reportinactive: true,
      }
    end

    it 'Will include ValuesPercentage in /etc/collectd.d/10-interface.conf' do
      should contain_file('interface.load').with_content(%r{ReportInactive true})
    end
  end

end

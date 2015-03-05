require 'spec_helper'

describe 'service_jenkins' do

  let :default_facts do
    {
      :concat_basedir         => '/tmp',
    }
  end

  variants = {
    :Debian => {
      :osfamily               => 'Debian',
      :operatingsystem        => 'Debian',
      :operatingsystemrelease => '7.8',
      :lsbdistcodename        => 'wheezy',
      :lsbdistid              => 'debian',
    },
    :Ubuntu => {
        :osfamily               => 'Debian',
        :operatingsystem        => 'Ubuntu',
        :operatingsystemrelease => '14.04',
        :lsbdistcodename        => 'trusty',
        :lsbdistid              => 'ubuntu',
    }
  }

  variants.each do |name, facts|

    context "on #{name} with default parameters" do
      let :facts do
        default_facts.merge(facts)
      end

      it { should contain_class('service_jenkins') }

      it { should contain_class('jenkins') }

      it { should contain_class('java') }

      it { should contain_class('apache') }
      it { should contain_class('apache::mod::proxy') }
      it { should contain_class('apache::mod::proxy_http') }

      it { should contain_file_line('Jenkins sysconfig setting PREFIX').with({
        'line' => 'PREFIX="/jenkins"',
      })}
      it { should contain_file_line('Jenkins sysconfig setting JENKINS_ARGS')}
    end

    context "on #{name} without apache" do
      let :facts do
        default_facts.merge(facts)
      end
      let :params do
        {
          :use_apache => false,
        }
      end

      it { should contain_class('service_jenkins') }
      it { should_not contain_class('apache') }
    end

  end

end

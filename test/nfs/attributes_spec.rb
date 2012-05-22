#
# Cookbook Name:: nfs
# Test:: attributes_spec 
#
# Author:: Fletcher Nichol
# Author:: Eric G. Wolfe
#
# Copyright 2012, Fletcher Nichol
# Copyright 2012, Eric G. Wolfe
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
require File.join(File.dirname(__FILE__), %w{.. support spec_helper})
require 'chef/node'
require 'chef/platform'

describe 'Ntp::Attributes::Default' do
  let(:attr_ns) { 'nfs' }

  before do
    @node = Chef::Node.new
    @node.consume_external_attrs(Mash.new(ohai_data), {})
    @node.from_file(File.join(File.dirname(__FILE__), %w{.. .. attributes default.rb}))
  end

  describe "for unknown platform" do
    let(:ohai_data) do
      { :platform => "unknown", :platform_version => "3.14" }
    end

    it "sets the statd port to 32765" do
      @node[attr_ns]['port']['statd'].must_equal 32765
    end

    it "sets the statd_out port to 32766" do
      @node[attr_ns]['port']['statd_out'].must_equal 32766
    end

    it "sets the mountd port to 32767" do
      @node[attr_ns]['port']['mountd'].must_equal 32767
    end

    it "sets the lockd port to 32768" do
      @node[attr_ns]['port']['lockd'].must_equal 32768
    end

    it "sets the package list to nfs-utils and portmap" do
      @node[attr_ns]['packages'].must_equal %w{ nfs-utils portmap }
    end

    it "sets the portmap service to portmap" do
      @node[attr_ns]['service']['portmap'].must_equal "portmap"
    end

    it "sets the lock service to nfslock" do
      @node[attr_ns]['service']['lock'].must_equal "nfslock"
    end

    it "sets the server service to nfs" do
      @node[attr_ns]['service']['server'].must_equal "nfs"
    end
  end

  describe "for centos 6 platform" do
    let(:ohai_data) do
      { :platform => "centos", :platform_version => "6.2" }
    end

    it "sets a package list to nfs-utils and rpcbind" do
      @node[attr_ns]['packages'] = %w{ nfs-utils rpcbind }
    end

    it "sets the portmap service to rpcbind" do
      @node[attr_ns]['service']['portmap'].must_equal "rpcbind"
    end
  end

  describe "for ubuntu 10 platform" do
    let(:ohai_data) do
      { :platform => "ubuntu", :platform_version => "10.04" }
    end

    it "sets a package list to nfs-common and portmap" do
      @node[attr_ns]['packages'].must_equal %w{ nfs-common portmap }
    end

    it "sets the lock service to statd" do
      @node[attr_ns]['service']['lock'].must_equal "statd"
    end

    it "sets the nfs service to nfs-kernel-server" do
      @node[attr_ns]['service']['server'].must_equal "nfs-kernel-server"
    end
  end

  describe "for ubuntu 11 platform" do
    let(:ohai_data) do
      { :platform => "ubuntu", :platform_version => "11.10" }
    end

    it "sets a package list to nfs-common and rpcbind" do
      @node[attr_ns]['packages'].must_equal %w{ nfs-common rpcbind }
    end

    it "sets the portmap service to rpcbind" do
      @node[attr_ns]['service']['portmap'].must_equal "rpcbind"
    end
  end

  describe "for ubuntu 12 platform" do
    let(:ohai_data) do
      { :platform => "ubuntu", :platform_version => "12.04" }
    end

    it "sets the portmap service to rpcbind-boot" do
      @node[attr_ns]['service']['portmap'].must_equal "rpcbind-boot"
    end
  end
end

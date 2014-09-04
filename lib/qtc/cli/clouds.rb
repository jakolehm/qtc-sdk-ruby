require 'qtc/client'
require_relative 'common'

module Qtc
  module Cli
    class Clouds
      include Common

      def list
        accounts = platform_client.get('/user/accounts')
        accounts['results'].each do |account|
          print color("~ #{account['name']} (#{account['id']})", :bold)
        end
      end

      def login
        pass = password("Personal Access Token (copy from https://console.qtcloudservices.com/#/user/profile):")
        inifile['platform']['token'] = pass

        response = platform_client(pass).get('/user/accounts', {}) rescue nil
        if response
          inifile.save
        else
          print color('Invalid Personal Access Token', :red)
        end
      end

      def logout
        inifile['platform'].delete('token')
        inifile.save(filename: ini_filename)
      end
    end
  end
end

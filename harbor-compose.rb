require 'digest/sha2'
require 'fileutils'
require 'open-uri'

class HarborCompose < Formula
  desc "The harbor-compose command: define and run multi-container Docker apps on Harbor"
  homepage "http://harbor.inturner.io"
  url "https://github.com/turnerlabs/harbor-compose/archive/v0.7.0.tar.gz"
  version "0.7.0"
  sha256 "fba5f34aee6704abb70952cef94186fa4abfc7651fae0b69fffd617c61632884"

  depends_on 'go' => :build

  def install
    binary        = 'harbor-compose'
    binary_url    = "https://github.com/turnerlabs/harbor-compose/releases/download/v#{version}/ncd_darwin_amd64"
    binary_sha256 = 'e28bf7d9fcc22cdfde0c7c8f31e3648a4847e7bda9cb69f309f24257eee3dd41'
    open(binary, 'wb') do |file|
      shasum = Digest::SHA256.new.update(open(binary_url).read.tap do |data|
        file << data
      end).hexdigest
      abort("Download failure: shasum(#{binary_url}) != #{binary_sha256}") unless shasum = binary_sha256
    end
    FileUtils.mkdir_p "#{prefix}/bin"
    FileUtils.mv binary, "#{prefix}/bin/#{binary}"
  end

  test do
    `harbor-compose` == <<-END_USAGE
Define and run multi-container Docker apps on Harbor

Usage:
  harbor-compose [command]

Available Commands:
  down        Stop your application
  generate    Generate docker-compose.yml and harbor-compose.yml files from an existing shipment
  init        Interactively create a harbor-compose.yml file
  login       Login to harbor
  logout      Logout of harbor
  logs        View output from containers
  ps          Lists shipment and container status
  up          Start your application
  version     Print version and exit

Flags:
  -f, --file string          Specify an alternate docker compose file (default "docker-compose.yml")
  -c, --harbor-file string   Specify an alternate harbor compose file (default "harbor-compose.yml")
  -h, --help                 help for harbor-compose
  -v, --verbose              Show more output

Use "harbor-compose [command] --help" for more information about a command.
END_USAGE
  end
end

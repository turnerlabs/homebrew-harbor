require 'fileutils'

class HarborCompose < Formula
  desc "The harbor-compose command: define and run multi-container Docker apps on Harbor"
  homepage "http://harbor.inturner.io"
  url "https://github.com/turnerlabs/harbor-compose/archive/v0.7.0.tar.gz"
  version "0.7.0"
  sha256 "fba5f34aee6704abb70952cef94186fa4abfc7651fae0b69fffd617c61632884"

  depends_on 'go' => :build

  def install
    FileUtils.mkdir_p 'src/github.com/turnerlabs'
    FileUtils.ln_s Dir.pwd, 'src/github.com/turnerlabs/harbor-compose'
    ENV['GOPATH']=Dir.pwd
    system *%w(go build)
    FileUtils.mkdir_p "#{prefix}/bin"
    FileUtils.mv "harbor-compose-#{version}", "#{prefix}/bin/harbor-compose"
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

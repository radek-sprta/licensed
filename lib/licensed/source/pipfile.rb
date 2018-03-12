# frozen_string_literal: true
require "json"

# /home/sprta/.local/share/virtualenvs/mariner-LwYtarCn/lib/python3.6/site-packages/cachalot-0.1.2.dist-info/metadata.json
#
module Licensed
  module Source
    class Pipfile
      def initialize(config)
        @config = config
      end

      def type
        "pipfile"
      end

      def enabled?
        @config.enabled?(type) && File.exist?(@config.pwd.join("Pipfile"))
      end

      def dependencies
        @dependencies ||= Dir.glob(dependencies_path.join("*-info/metadata.json")).map do |file|
          package = JSON.parse(File.read(file))
          path = file.dirname.to_path
          Dependency.new(path, {
            "type"     => type,
            "name"     => package["name"],
            "version"  => package["version"],
            "summary"  => package["summary"],
            "homepage" => package["project_urls"]["Home"]
          })
        end
      end

      def venv_path
        Licensed::Shell.execute("pipenv", "--venv")
      end
      
      def dependencies_path
        venv_path.join("lib/python*/site-packages/")
      end
    end
  end
end

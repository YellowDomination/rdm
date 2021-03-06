module Rdm
  module CLI
    class GenPackage
      class << self
        def run(package_name:, current_path:, path:, locals: {}, stdout: $stdout)
          Rdm::CLI::GenPackage.new(package_name, current_path, path, locals, stdout).run
        end
      end

      def initialize(package_name, current_path, path, locals, stdout)
        @current_path = current_path
        @path         = path
        @package_name = package_name
        @locals       = locals
        @stdout       = stdout
      end

      def run
        generated_files_list = Rdm::Gen::Package.generate(
          current_path: @current_path,
          local_path:   @path,
          package_name: @package_name,
          locals:       @locals
        )

        generated_files_list.compact.each { |file| @stdout.puts "Generated: #{file}" }
      rescue Errno::ENOENT => e
        @stdout.puts "Error occurred. Possible reasons:\n #{Rdm::SOURCE_FILENAME} not found. Please run on directory containing #{Rdm::SOURCE_FILENAME} \n#{e.inspect}"
      rescue Rdm::Errors::PackageExists
        @stdout.puts 'Error. Package already exist. Package was not generated'
      rescue Rdm::Errors::PackageNameNotSpecified
        @stdout.puts "Package name was not specified!"
      rescue Rdm::Errors::SourceFileDoesNotExist => e
        @stdout.puts "Rdm.packages was not found. Run 'rdm init' to create it"
      rescue Rdm::Errors::PackageDirExists => e
        @stdout.puts "Error. Directory #{e.message} exists. Package was not generated"
      rescue NoMethodError => e
        @stdout.puts e.message
      end
    end
  end
end

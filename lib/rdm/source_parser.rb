class Rdm::SourceParser
  class << self

    # Read source file, parse and init it's packages and configs
    # @param source_path [String] Source file path
    # @return [Rdm::Source] Source
    def read_and_init_source(source_path)
      root_path = File.dirname(source_path)
      source_content = File.open(source_path).read
      source = parse(source_content)

      # Setup Rdm
      if block = source.setup_block
        Rdm.setup(&block)
      end

      # Parse and set packages
      packages = {}
      source.package_paths.each do |package_path|
        package_full_path = File.join(root_path, package_path)
        package_rb_path = File.join(package_full_path, Rdm::PACKAGE_FILENAME)
        package_content = File.open(package_rb_path).read
        package = package_parser.parse(package_content)
        package.path = package_full_path
        packages[package.name] = package
      end
      source.packages = packages

      source
    end

    # Parse source file and return Source object
    # @param source_content [String] Source file content
    # @return [Rdm::Source] Source
    def parse(source_content)
      source = Rdm::Source.new
      source.instance_eval(source_content)
      source
    end

    private
      def package_parser
        Rdm::PackageParser
      end
  end
end
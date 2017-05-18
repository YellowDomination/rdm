require "spec_helper"

describe Rdm::Git::RepositoryLocator do
  include SetupHelper

  subject { described_class }

  context "::locate" do
    before do
      @example_path = initialize_example_project
    end

    after do
      reset_example_project(path: @example_path)
    end

    it "returns root of git repository if initialized for existing path" do
      %x( cd #{@example_path} && git init )

      expect(subject.locate(File.join(@example_path, "application"))).to eq(@example_path)
    end

    it "returns root of git repository if initialized for non existing path" do
      %x( cd #{@example_path} && git init )

      expect(subject.locate(File.join(@example_path, "non_existing_path"))).to eq(@example_path)
    end

    it "raises error Rdm::Errors::GitRepositoryNotInitialized if not initialized" do
      expect{
        subject.locate(File.join(@example_path, "application"))
      }
    end
  end
end
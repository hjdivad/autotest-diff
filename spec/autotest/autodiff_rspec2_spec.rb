require 'spec_helper'

describe Autotest::AutodiffRspec2 do
  let(:autotest){ Autotest::AutodiffRspec2.new }
  before{ FileUtils.stub!(:cp) }
  before{ FileUtils.stub!(:mkdir_p) }
  before{ autotest.stub!(:`){ "" }}

  let(:single_file_test){{ "some_spec.rb" => [] }}
  let(:multi_file_test){{ "some_spec.rb" => [], "some_other_spec.rb" => [] }}

  describe "#make_test_cmd" do
    context "testing a single file" do
      shared_examples_for "updating the cache" do
        it "caches the tested file" do
          autotest.should_receive(:cache).with("some_spec.rb")
          autotest.make_test_cmd  single_file_test
        end
      end

      context "with no cached version" do
        before{ autotest.should_receive(:cached?).and_return false }

        it_handles  "updating the cache"

        it "invokes and returns the result of super" do
          autotest.make_test_cmd( single_file_test ).should == "super"
        end

        it "stores a cached version of the file" do
          autotest.should_receive(:cache).with  "some_spec.rb"
          autotest.make_test_cmd  single_file_test
        end
      end

      context "with a cached version" do
        before{ autotest.should_receive(:cached?).at_least(:once).and_return true }

        it_handles  "updating the cache"

        context "that differs" do
          before{ autotest.stub!(:differing_lines){ [10,30] }}

          it "runs examples that have changed" do
            autotest.make_test_cmd( single_file_test ).should =~ /--line_number 10/
            autotest.make_test_cmd( single_file_test ).should =~ /--line_number 30/
          end

          # TODO 2: runs new examples?
        end

        context "that does not differ" do
          before{ autotest.stub!(:differing_lines){ [] }}

          # TODO 2: maybe repeats the last diff if the timestamp on the spec
          # file is unchanged?
          it "invokes and returns the result of super" do
            autotest.make_test_cmd( single_file_test ).should == "super"
          end
        end
      end
    end

    context "testing multiple files" do
      it "invokes and returns the result of super" do
        autotest.make_test_cmd( single_file_test ).should == "super"
      end

      it "does not cache anything" do
        autotest.should_not_receive(:cache)
        autotest.make_test_cmd  multi_file_test
      end
    end
  end

  describe "#cache" do
    it "stores a copy of the file specified as an argument, in .autodiff/cache" do
      FileUtils.should_receive(:cp).with( "some_spec.rb", ".autodiff/cache/some_spec.rb" )
      autotest.cache "some_spec.rb"
    end
  end

  describe "#differing_lines" do
    context "with a cached version" do
      before{ autotest.stub!(:cached?){ true }}

      it "invokes diff and sed to extract the differing lines" do
        cmd_ran = nil
        autotest.should_receive(:`).and_return{|a| cmd_ran = a; "" }
        autotest.differing_lines( "some_spec.rb" )

        cmd_ran.should_not  be_nil
        cmd_ran.should      =~ /diff/
        cmd_ran.should      =~ /sed/
      end

      it "returns an array of lines reported by diff as differing" do
        autotest.should_receive(:`).and_return("11\n37")
        autotest.differing_lines( "some_spec.rb" ).should == [11, 37]
      end
    end
  end
end

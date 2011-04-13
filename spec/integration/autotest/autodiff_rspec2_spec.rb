require 'spec_helper'

describe Autotest::AutodiffRspec2 do
  let(:autotest){ Autotest::AutodiffRspec2.new }
  let(:one_example_new_lines){{ "spec/new_lines_spec.rb" => [] }}
  let(:one_example_changed_lines){{ "spec/changed_lines_spec.rb" => [] }}
  let(:two_examples_changed_lines){{ "spec/changed_lines_multiple_examples_spec.rb" => [] }}

  context "when there is no cache" do
    use_fixture 'no-cache'

    it "creates the cache" do
      ".autodiff/cache".should_not  exist
      autotest.make_test_cmd  one_example_new_lines
      ".autodiff/cache".should  exist
    end
  end

  context "when there is a cache" do
    use_fixture 'with-cache'

    context "with new lines in one example" do
      it "only invokes the example that changed" do
        command = autotest.make_test_cmd  one_example_new_lines
        command.should  =~ /--line_number 8/
      end
    end

    context "with modified lines in one example" do
      it "only invokes the example that changed" do
        command = autotest.make_test_cmd  one_example_changed_lines
        command.should  specify_lines 7
      end
    end

    context "with modified lines in multiple examples" do
      it "invokes both examples" do
        command = autotest.make_test_cmd  two_examples_changed_lines
        command.should  specify_lines 7, 11
      end
    end
  end
end

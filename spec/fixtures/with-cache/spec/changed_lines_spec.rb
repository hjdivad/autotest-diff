require 'spec_helper'
require 'something'

describe Something do

  it "does something nifty" do
    whatever.should     do_something_really_nifty
  end

  it "doesn't do bad things" do
    whatever.should_not do_bad_things
  end
end

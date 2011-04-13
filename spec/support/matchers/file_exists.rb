RSpec::Matchers.define :exist do
  match do |actual|
    File.exists? actual
  end
end

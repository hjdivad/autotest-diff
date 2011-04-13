RSpec::Matchers.define :specify_lines do |*lines|
  match do |command|
    specified_lines = command.scan( /--line_number (\d+)/ ).flatten.map &:to_i
    specified_lines.sort == lines.sort
  end
end
RSpec::Matchers.define :exist do
  match do |actual|
    File.exists? actual
  end
end

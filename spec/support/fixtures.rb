require 'fileutils'

def use_fixture name
  cur_dir       = Dir.pwd
  tmp_dir       = "#{File.dirname __FILE__}/../tmp"
  fixtures_dir  = "#{File.dirname __FILE__}/../fixtures"

  before do
    FileUtils.mkdir_p tmp_dir
    FileUtils.cp_r "#{fixtures_dir}/#{name}", tmp_dir
    Dir.chdir      "#{tmp_dir}/#{name}"
  end

  after do
    FileUtils.rm_rf tmp_dir
    Dir.chdir       cur_dir
  end
end

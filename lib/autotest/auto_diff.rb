module Autotest::AutoDiff
  def make_test_cmd files_to_test_hash
    files_to_test = files_to_test_hash.keys
    return super if files_to_test.size != 1

    simple_cmd    = super
    file_to_test  = files_to_test.first
    if cached? file_to_test
      line_args = differing_lines( file_to_test ).map{|l| "--line_number #{l}" }.join " "
      "#{simple_cmd} #{line_args}".strip
    else
      simple_cmd
    end.tap{ cache file_to_test }
  end

  def cached_copy_path file
    ".autodiff/cache/#{file}"
  end

  def cached? file
    File.exists? cached_copy_path file
  end

  def cache file
    cache_file = cached_copy_path( file )
    FileUtils.mkdir_p   File.dirname cache_file
    FileUtils.cp file,  cache_file
  end

  def differing_lines file
    raise "No cached version of #{file}" unless cached? file
    `#{diff_cmd file}`.chomp.split( "\n" ).map{ |l| l.to_i }
  end

  def diff_cmd( file )
    raise "No cached version of #{file}" unless cached? file
    diff_part = "diff -w -B --strip-trailing-cr #{file} #{cached_copy_path file}"
    sed_part  = "sed -e '/^[^[:digit:]]/d' -e 's/^\([[:digit:]]\{1,\}\).*/\1/'"
    "#{diff_part} | #{sed_part}"
  end
end


Autotest.add_hook :post_initialize do |at|
  at.add_exception  %r{.autodiff/.*}
end


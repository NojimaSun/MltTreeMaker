#encoding : utf-8
#
# tree: 引数で指定されたディレクトリ以下のファイルを
#       再帰的に木構造として表示する.
require 'optparse'

options = ARGV.getopts('aF')
LASTLINE="┗━"
LINE="┣━"
TATELINE="┃ 　"
SPACELINE="　 　 "
# parentは絶対パス.
def display_entries(parent, prefix, options)
  # '.', '..'を除く. 無限に再帰することを防ぐ
  entries = Dir.entries(parent).delete_if do |entry|
    entry == '.' or entry == '..' or !options['a'] && entry.start_with?('.')
  end
  entries.each_with_index do |entry, index|
    fullpath = File.join(parent, entry)
    entry = f_option(parent, entry) if options['F']
    # 最後の要素かどうか
    if index == entries.size - 1
      puts "#{prefix}#{LASTLINE}#{entry}"
      next_prefix = "#{prefix}#{SPACELINE}"
    else
      puts "#{prefix}#{LINE}#{entry}"
      next_prefix = "#{prefix}#{TATELINE}"
    end
    if File.directory? fullpath
      display_entries(fullpath, next_prefix, options)
    end
  end
end

def f_option(parent, entry)
  case File.ftype(File.join(parent, entry))
  when "file"
    if File.executable? File.join(parent, entry)
      "#{entry}*"
    else
      entry
    end
  when "directory"
    "#{entry}/"
  when "link"
    "#{entry}@"
  else
    entry
  end
end

target = ARGV[0] || '.'
target_fullpath = File.absolute_path target
init_prefix = ''

puts target
display_entries target_fullpath, init_prefix, options
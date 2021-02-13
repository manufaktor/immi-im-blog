require 'bundler/setup'
require 'kramdown'
require 'kramdown-parser-gfm'
require 'rouge'

def convert_markdown_to_html_files
  Dir.glob('posts/*.md').each do |file|
    markdown_content = File.read(file)

    html_content = Kramdown::Document.new(
      markdown_content,
      input: 'GFM',
      syntax_highlighter: 'rouge',
      syntax_highlighter_opts: {},
    ).to_html

    html_filename = "./public/#{File.basename(file,'.*')}.html"

    log 'Writing', html_filename

    File.open(html_filename, 'w') do |file|
      file.write(html_content)
    end
  end
end

def log(*args)
  puts args.join(" ")
end


convert_markdown_to_html_files

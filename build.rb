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

if ARGV.include?('-w')
  require 'webrick'

  root = File.expand_path './public'
  request_callback = Proc.new do |req, res|
    convert_markdown_to_html_files
  end

  server = WEBrick::HTTPServer.new(:Port => 8000, :DocumentRoot => root, :RequestCallback => request_callback)

  trap 'INT' do
    server.shutdown
  end

  server.start
else
  convert_markdown_to_html_files
end

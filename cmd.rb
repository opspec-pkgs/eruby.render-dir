#!/usr/bin/env ruby

# from https://gist.github.com/bastman/55f1c5a5bb474e472d5e

require 'erb'
require 'json'
require 'pathname'

class ErbRenderer < OpenStruct
    # https://stackoverflow.com/questions/1572660/is-there-a-way-to-initialize-an-object-through-a-hash
    def initialize(h)
      h.each {|k,v| instance_variable_set("@#{k}",v)}
    end

    # https://stackoverflow.com/questions/8954706/render-an-erb-template-with-values-from-a-hash
    def render(template)
        ERB.new(template).result(binding)
    end
end

params=JSON.parse(File.read('/data'))
renderer = ErbRenderer.new(params)

# https://alvinalexander.com/blog/post/ruby/ruby-how-process-each-file-directory-name-pattern
Dir.glob("/templates/**/*") {|filename|
  result_path = filename.sub('/templates', '/result').delete_suffix('.erb')
  if File.directory? filename
    Dir.mkdir result_path
  else
    template=File.read(filename)
    result = renderer.render(template)
    
    # output to file
    output = File.new(result_path, 'w')
    output.puts(result)
    output.close
  end
}

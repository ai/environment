# encoding: utf-8
require 'rubygems'
require 'pp'
require 'irb/completion'
require 'irb/ext/save-history'
 
IRB.conf[:AUTO_INDENT] = true
IRB.conf[:USE_READLINE] = true
IRB.conf[:SAVE_HISTORY] = 100
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb_history" 

IRB.conf[:PROMPT][:ARROW] = {
    :PROMPT_N => "➜ ",
    :PROMPT_I => "➜ ",
    :PROMPT_S => nil,
    :PROMPT_C => "➜ ",
    :RETURN   => "%s\n"
}
IRB.conf[:PROMPT_MODE] = :ARROW

def lib
  required = false
  Dir.glob('lib/*.rb') do |file|
    required |= require file
  end
  required
end

class Object
  def local_methods(klass = Object)
    (methods - klass.instance_methods).sort
  end
end

begin
  gem 'wirble'
  require 'wirble'
  Wirble.init
  Wirble.colorize
rescue LoadError
end

require 'rubygems'
require 'pp'
require 'irb/completion'
require 'irb/ext/save-history'
 
IRB.conf[:AUTO_INDENT] = true
IRB.conf[:USE_READLINE] = true
IRB.conf[:SAVE_HISTORY] = 100
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb_history" 
IRB.conf[:PROMPT_MODE] = :SIMPLE

def lib
  required = false
  Dir.glob('lib/*.rb') do |file|
    required |= require file
  end
  required
end

class Object
  def local_methods
    (methods - Object.instance_methods).sort
  end
end

gem 'wirble'
require 'wirble'
Wirble.colorize

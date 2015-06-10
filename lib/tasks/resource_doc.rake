require 'straight-server-kit'
require 'active_support/all'

namespace :doc do
  task :_resources do
    resources = StraightServerKit::Client.resources

    resources.each do |key, klass|
      if klass.name.in?((ENV['SKIP_CLASSES'] || '').split(','))
        next
      end

      puts "## #{klass.name.demodulize.underscore.humanize}"
      puts
      puts "    client = StraightServerKit::Client.new"
      puts "    client.#{key} #=> #{klass.name}"
      puts
      puts "Actions supported: "
      puts
      klass._resources.each do |action|
        action_options = action.path.scan(/\:[\w_\-]+/i)
        params         = []

        if action.body && action.body.arity > 0
          params << klass.name.demodulize.underscore.downcase.gsub('_resource', '')
        end

        if action_options.any?
          action_string = action_options.map do |option|
            option.gsub!(/^\:/, '')
            "#{option}: '#{option}'"
          end.join(', ')

          params << action_string
        end

        action.query_keys.each do |key|
          params << "#{key}: '#{key}'"
        end

        puts "* `client.#{key}.#{action.name}(#{params.join(', ')})`"
      end
      puts
      puts
    end
  end
end

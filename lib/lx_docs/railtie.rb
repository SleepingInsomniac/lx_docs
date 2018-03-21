module LxDocs
  class Railtie < Rails::Railtie

    rake_tasks do
      namespace :lx_docs do
        desc "Generate"
        task :generate => :environment do
      
          versions = {}

          routes = Rails.application.routes.routes.map do |route|
            next unless route.defaults[:controller]
            controller_path = route.defaults[:controller] + '_controller'
            controller_class = controller_path.classify.constantize
            controller_file_path = Rails.root.join('app', 'controllers', controller_path + '.rb').to_s

            next unless File.exists?(controller_file_path)

            defined_in = controller_class.to_s.split('::').tap{ |a| a.pop }.join('/').downcase
            defined_in = 'root' if defined_in.blank?

            versions[defined_in] ||= { controllers: {} }
            controllers = versions[defined_in][:controllers]

            action_name = route.defaults[:action].to_sym
            action_method = controller_class.instance_method(action_name)

            controllers[controller_path] ||= {
              controller: controller_path.classify,
              source_location: {
                file: controller_file_path[Rails.root.to_s.length..-1]
              }
            }

            controllers[controller_path][:actions] ||= {}
            controllers[controller_path][:actions][action_name] ||= { paths: [], verbs: [], formats: [] }
            controllers[controller_path][:actions][action_name][:paths].push(route.path.spec.to_s).uniq!
            controllers[controller_path][:actions][action_name][:verbs].push(route.verb).uniq!
            controllers[controller_path][:actions][action_name][:formats].push(route.defaults[:format]).uniq!

            action_file, action_file_line = action_method.source_location

            controllers[controller_path][:actions][action_name][:source_location] ||= {
              file: action_file[Rails.root.to_s.length..-1],
              line: action_file_line
            }
          end

          puts JSON.pretty_generate(versions)
        end
      end
    end 
    
  end
end

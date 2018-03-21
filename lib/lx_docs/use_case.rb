require 'json'

module LxDocs
  class UseCase
    def self.defined
      @use_cases ||= {}
    end

    def self.add(title, version, *args, &block)
      self.defined[version] ||= {}
      self.defined[version][title] = new(title, version, *args).tap do |use_case|
        use_case.instance_eval(&block)
      end
    end

    attr_reader :info

    def initialize(title, version, controller = nil, action = nil)
      @version = version
      @controller = controller
      @action = action
      @info = {
        title: title,
        description: '',
        parameters: {},
        responses: [],
        examples: [],
        includes: []
      }
    end

    def description(value)
      @info[:description] = value
    end

    def parameter(name, **opts)
      @info[:parameters][name.to_sym] = opts
    end

    def example(value)
      @info[:examples] << value
    end

    def response(code, body = nil, description = nil)
      @info[:responses] << {
        code: code,
        body: body,
        description: description
      }
    end

    def includes(other)
      @info[:includes] << other
      other = LxDocs::UseCase.defined[@version][other]
      @info[:parameters].merge!(other.info[:parameters])
      @info[:responses] |= other.info[:responses]
      @info[:examples] |= other.info[:examples]
    end

    def to_json(*args)
      @info.to_json(*args)
    end
  end
end

# LxDocs::UseCase.add('pagination', 'Api::V1') do
#   parameter :page, type: 'integer', default: 1
#   parameter :limit, type: 'integer', default: 10
# end
#
# LxDocs::UseCase.add('listing shoes', 'Api::V1', 'Shoes', :index) do
#   description "Get an index of shoes"
#
#   example "api/v1/shoes?page=1&limit=10"
#
#   response 200
#   response 403, { error: 'Forbidden' }.to_json, "When the user is not logged in"
#
#   includes 'pagination'
# end
#
# puts JSON.pretty_generate(LxDocs::UseCase.defined)
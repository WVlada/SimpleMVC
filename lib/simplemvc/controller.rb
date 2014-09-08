require 'erubis'
#ovo je PARENT za sve kontrollere u aplikaciji

module Simplemvc
  class Controller
    attr_reader :request
    def initialize(env)
     @request ||= Rack::Request.new(env)
    end

    def params
      request.params
    end
    #sada mozemo da koristimo request u konktrolerima

    def render(view_name, locals = {})
      filename = File.join("app", "views", controller_name, "#{view_name}.erb")
      template = File.read(filename)
      Erubis::Eruby.new(template).result(locals)
    end

    def controller_name
      self.class.to_s.gsub(/Controller$/, "").to_snake_case
    end

  end
end
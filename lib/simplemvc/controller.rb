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

    def response(body, status=200, header = {})#uzima sve parametre koji su potrbni za Rack response objekat
    @response = Rack::Response.new(body,status,header)
    end

    def get_response
      @response
    end

    def render(*args) #kreiracemo response i onda delegirati render render_template-u
    response(render_template(*args))
      #ovo je delegiranje rendera na render_template
    end
    def render_template(view_name, locals = {})
      filename = File.join("app", "views", controller_name, "#{view_name}.erb")
      template = File.read(filename)

      varijable = {}
      instance_variables.each do |var| #imamo :@name, hocemo :name
        key = var.to_s.gsub("@","").to_sym
        varijable[key] = instance_variable_get(var)
      end

      #ovo znaci da "name" varijablu ne uzima vise iz url-a, nego iz kontrolera,
      #gde smo i stavili @name = Vlada
      Erubis::Eruby.new(template).result(locals.merge(varijable))
      #dodajemo varijable localsima
    end

    def controller_name
      self.class.to_s.gsub(/Controller$/, "").to_snake_case
    end

  end
end
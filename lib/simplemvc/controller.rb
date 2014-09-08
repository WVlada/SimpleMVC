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
    def dispatch(action)
      content = self.send(action) #ovo ce postaviti RESPONSE objekat
      #tj kada send-ujemo akciju, to je isto sto i render action
      if get_response
        get_response
      else #ako nemamo "render" u metodu
        render(action)
        get_response
      end
    end

    def self.action(action_name)
      #vratice lambdu
      ->(env) { self.new(env).dispatch(action_name)}
      #insancirace kontroler u kojem smo sa ENV-om, kako bismo imali REQUEST objekat
      # i onda ce dispacirati action name
      #dispatc salje kontroleru akciju i dobija RESPONSE i vraca RESPONSE
    end
  end
end
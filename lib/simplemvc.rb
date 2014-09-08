require "simplemvc/version"
require "simplemvc/controller.rb"
require "simplemvc/utils.rb"
require "simplemvc/dependencies.rb"
require "simplemvc/routing.rb"


module Simplemvc
  class Application
    def call(env)

      if env["PATH_INFO"] == "/favicon.ico"
        return [500, {},[] ] # ovo meni ne treba na windowsu, njemu treba
      end

      get_rack_app(env).call(env)



    end

  end
end

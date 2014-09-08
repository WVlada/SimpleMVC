module Simplemvc

  class Router
    def initialize
      @routes = []
    end
    def match(url, *args) #mi cemo imati samo prvi argument,
    # ali stavljamo *args ako bude nekad potrebe za vise argumenata
      # match metod treba da parsuje url i da obezbedi routove
    target = args.shift if args.size > 0 # shift uzima prvi element arraya i ostavlja array bez njega
    @routes << {
          regexp: Regexp.new("^#{url}$"),#pocetak linije ^ i kraj linije $
          target: target
      }
    end

    def check_url(url)
      @routes.each do |route|
      match = route[:regexp].match(url)
        if match # ako match postoji
          if route[:target] =~ /^([^#]+)#([^#]+)$/ #i ako target odgovara...
            #prva grupa su svi karakteri osim #, i druga grupa isto
            controller_name = $1.to_camel_case
            controller = Object.const_get("#{controller_name}Controller")
            return controller.action($2)
          end
        end
      end
      end
    end


    class Application #ovde cemo da otvorimo Application, i da definisemo "route" metod iz config.ru fajla

      def route(&block)
      @router ||= Simplemvc::Router.new
      @router.instance_eval(&block)
      end

      def get_rack_app(env)
        @router.check_url(env["PATH_INFO"])
      end

    end


end
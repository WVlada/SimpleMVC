module Simplemvc

  class Router
    def initialize
      @routes = [] # ovo je instanca samo prazne kolekcije
    end
    def match(url, *args) #mi cemo imati samo prvi argument,
    # ali stavljamo *args ako bude nekad potrebe za vise argumenata
      # match metod treba da parsuje url i da obezbedi routove
      target = nil
      target = args.shift if args.size > 0 # shift uzima prvi element arraya i ostavlja array bez njega

      url_parts = url.split("/")
      url_parts.select! {|part| !part.empty?}

      placeholders = []
      regexp_parts = url_parts.map do |part|
        if part[0] == ":"
          placeholders << part[1..-1]
          "([A-za-z0-9_]+)"
        else
          part
        end
      end

      regexp = regexp_parts.join('/')

      @routes << {
        regexp: Regexp.new("^/#{regexp}$"),#pocetak linije ^ i kraj linije $
        target: target,
        placeholders: placeholders
      }

      #   @routes << {
   #       regexp: Regexp.new("^#{url}$"),#pocetak linije ^ i kraj linije $
   #       target: target
   #   }
    end

    def check_url(url)
      @routes.each do |route|
      match = route[:regexp].match(url)#ovo je rubijem MATCH. tj Regexpov match
        if match # ako match postoji

          placeholders = {}
          route[:placeholders].each_with_index do |placeholder,index|
            placeholders[placeholder] = match.captures[index]
          end

          if route[:target]
            return convert_target(route[:target])
          else
            controller = placeholders["controller"]
            action = placeholders["action"]
            return convert_target("#{controller}##{action}")
          end
        end
      end
      end
  def convert_target(target)
    if target =~ /^([^#]+)#([^#]+)$/ #i ako target odgovara...
      #prva grupa su svi karakteri osim #, i druga grupa isto
      controller_name = $1.to_camel_case
      controller = Object.const_get("#{controller_name}Controller")
      return controller.action($2)
    end
  end
  end


    class Application #ovde cemo da otvorimo Application, i da definisemo "route" metod iz config.ru fajla

      def route(&block)
      @router ||= Simplemvc::Router.new
      # @router je instanca KLASE
      @router.instance_eval(&block)#evaluatujemo block u kontekstu Router-a
      end

      def get_rack_app(env)
        @router.check_url(env["PATH_INFO"])
      end

    end


end
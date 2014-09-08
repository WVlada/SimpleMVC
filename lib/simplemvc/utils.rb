class String
  # ovo se u Rails-u nalazi u ActionControlleru - INFLECTION klasi
  def to_snake_case
    self.gsub("::", "/").
    gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2'). #FOOBar => foo_bar
    gsub(/([a-z\d])([A-Z])/, '\1_\2').     #FO86OBAR => fo86_o_bar
    tr("-", "_").         # promeni - u _
    downcase
  end

  def to_camel_case
    return self if self !~ /_/ && self =~ /[A-Z]+.*/ # ako nema _ i ako je u formatu: bilo koji broj AY i bilo sta pored
    split('_').map {|str| str.capitalize}.join # hi_there => HiThere
  end

end
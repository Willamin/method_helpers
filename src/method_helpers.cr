require "./method_helpers/*"

# TODO: Write documentation for `MethodHelpers`
module MethodHelpers
  record Arg, argname : String, argtype : String?

  class Method
    property name : String?
    property args : Array(Arg)?
    property return_type : String?

    def initialize; end

    def arity
      args.try &.size || 0
    end
  end

  class MethodArray < Array(Method)
    def names : Array(String)
      names = [] of String
      self.each do |method|
        method.name.try do |name|
          names << name
        end
      end
      names.uniq
    end

    def names_with_arity : Array(String)
      names = [] of String
      self.each do |method|
        method.name.try do |name|
          names << "#{name}/#{method.arity}"
        end
      end
      names.uniq
    end
  end

  macro methods
    ms = MethodHelpers::MethodArray.new
    {% for method in @type.methods %}
      ms << MethodHelpers::Method.new.tap do |m|
        m.name = {{method.name.stringify}}
        args = [] of Methods::Arg
        {% for arg in method.args %}
          {% if arg.restriction.stringify != "" %}
            args << Methods::Arg.new({{arg.name.stringify}}, nil)
          {% else %}
            args << Methods::Arg.new({{arg.name.stringify}}, {{arg.restriction}})
          {% end %}
        {% end %}
        m.args = args

        {% if method.return_type.stringify != "" %}
          m.return_type = {{method.return_type.stringify}}
        {% end %}
      end
    {% end %}
    ms
  end
end

class Object
  include Methods
end

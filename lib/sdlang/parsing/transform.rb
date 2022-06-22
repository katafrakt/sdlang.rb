require "parslet"
require "sdlang/parsing/ast"

module SDLang
  class Transform < Parslet::Transform
    # simple things
    rule(integer: simple(:integer)) { SDLang::AST::Integer.new(integer) }
    rule(float: simple(:float)) { SDLang::AST::Float.new(float) }
    rule(string: simple(:string)) { SDLang::AST::String.new(string) }
    rule(true: simple(:true)) { SDLang::AST::Boolean.new(true) }
    rule(false: simple(:false)) { SDLang::AST::Boolean.new(false) }
    rule(date: simple(:date)) { SDLang::AST::Date.new(date) }
    rule(datetime: simple(:datetime)) { SDLang::AST::DateTime.new(datetime) }

    # datetime
    rule(
      date: simple(:date),
      time: simple(:time),
      timezone: simple(:timezone)
    ) { SDLang::AST::DateTime.new(date, time, timezone) }

    # time
    rule(
      time: simple(:time),
      timezone: simple(:timezone)
    ) { SDLang::AST::Time.new(time, timezone) }

    # regular tag with namespace
    rule(
      identifier: simple(:name),
      namespace: simple(:namespace),
      values: sequence(:values),
      attributes: sequence(:attributes),
      children: subtree(:children)
    ) { SDLang::AST::Tag.new(name, namespace, values, attributes, children) }

    # regular tag without namespace
    rule(
      identifier: simple(:name),
      values: sequence(:values),
      attributes: sequence(:attributes),
      children: subtree(:children)
    ) { SDLang::AST::Tag.new(name, nil, values, attributes, children) }

    # anonymous tag
    rule(
      values: sequence(:values),
      attributes: sequence(:attributes),
      children: subtree(:children)
    ) { SDLang::AST::Tag.new("", nil, values, attributes, children) }

    rule(
      identifier: simple(:name),
      value: simple(:value)
    ) { SDLang::AST::Attribute.new(name, value) }
  end
end

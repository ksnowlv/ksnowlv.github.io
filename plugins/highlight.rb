# This is the Octopress Gravatar plugin
#
# Place this file in your plugin directory and you have an _highlight_ keyword to create a span with fluo class containing your text
#
# Usage: {% highlight this is a great piece of wisdom %}, this is not.
#
# Paolo Perego, <thesp0nge@gmail.com>, v20120828.a
# repo@github: https://github.com/thesp0nge/octopress_highlight_plugin
# twitter: @thesp0nge
# blog: http://armoredcode.com
#

module Jekyll
  class Highlight < Liquid::Tag
    @text = ""

    def initialize(tagname, text, tokens)
      @text = text
    end

    def render(context)
      "<span class=\"fluo\">#{@text}</span>"
    end

  end


end
Liquid::Template.register_tag('highlight', Jekyll::Highlight)

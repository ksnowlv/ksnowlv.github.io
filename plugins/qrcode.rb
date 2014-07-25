module Jekyll
  class QRCode < Liquid::Tag
    @size = ""
    @img = nil

    def initialize(tagname, markup, tokens)
        super
        if markup =~ /([^ ]+x[^ ]+ )?(.*)/i
            if !$1.nil?
                @size = $1.strip
            else
                @size = "130x130"
            end
        end
        @img = ImageTag.new('img', $2, nil)

    end

    def render(context)
        url = @img.img_info['src']
        @img.img_info['src'] = "http://chart.apis.google.com/chart?chs=#{@size}&cht=qr&chld=|0&chco=165B94&chl=#{url.start_with?('/') ? context.registers[:site].config['url']+url : url}"
        "<a href=#{url}>#{@img.render(context)}</a>"
    end

  end
end
Liquid::Template.register_tag('qrcode', Jekyll::QRCode)

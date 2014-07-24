# Usage: {% app_store_developer 626825948 %}

require 'cgi'
require 'open-uri'
require 'json'

module Jekyll

  class AppstoreDevTag < Liquid::Tag

    def initialize(tag_name, text, token)
      super
      @text = text
      @local_folder = File.expand_path "../.app_store_developer", File.dirname(__FILE__)
      FileUtils.mkdir_p @local_folder
    end

    def app_store_url_with_id(developer_id)
      "http://itunes.apple.com/cn/lookup?id=#{developer_id}&entity=software"
    end

    def render(context)
      if parts = @text.match(/([\d]*)/)
        app_store_id = parts[1].strip
        json = get_app_local_data(app_store_id) || get_app_store_data(app_store_id)
        html_output_for(json)
      else
        ""
      end
    end

    def html_output_for(json)
			json = json['results']
			json.shift

			result = ""
			result = result + <<-JS
<style type="text/css">
.flip-container, .front, .back {
	width: 120px;
	height: 120px;
}
.flip-container {
  -webkit-perspective: 1000;
	-moz-perspective: 1000;
	perspective: 1000;
}
.flip-container:hover .flipper, .flip-container.hover .flipper {
	-webkit-transform: rotateY(180deg);
  -moz-transform: rotateY(180deg);
  transform: rotateY(180deg);
}
.flipper {
  -webkit-transition: 0.6s;
	-webkit-transform-style: preserve-3d;

	-moz-transition: 0.6s;
	-moz-transform-style: preserve-3d;
	transition: 0.6s;
	transform-style: preserve-3d;

	position: relative;
}
.front, .back {
  -webkit-backface-visibility: hidden;
	-moz-backface-visibility: hidden;
	backface-visibility: hidden;

	position: absolute;
	top: 0;
	left: 0;
}
.front {
	z-index: 2;
}
.back {
	transform: rotateY(180deg);
	-webkit-transform: rotateY(180deg);
	-moz-transform: rotateY(180deg);
}
</style>
                          JS

			json.each do |app|
				name = app['trackName']
				icon = app['artworkUrl512']
				link = app['trackViewUrl']
				bundleId = app['bundleId'].strip.gsub('.', '-').downcase
				qr_image = "http://chart.apis.google.com/chart?chs=120x120&cht=qr&chld=|0&chco=165B94&chl=#{link}"

				result = result + <<-HTML

<li>
<div align='center'>
<div class="flip-container" ontouchstart='this.classList.toggle('hover');' style='margin-bottom: 10px'>
<div class="flipper" style='text-align: center' align='center'>
<div class='front'>
<a class='#{bundleId}' href='#{link}' style='text-decoration: none !important; white-space: normal' target='_blank'>
  <img id='img_#{bundleId}' src='#{icon}' class='#{bundleId}' style='width:120px; height:120px; border: 0em; border-radius:22px' />
</a>
</div>
<div class='back'>
<a class='#{bundleId}' href='#{link}' style='text-decoration: none !important; white-space: normal' target='_blank'>
  <img id='img_#{bundleId}_qr' src='#{qr_image}' class='#{bundleId}' style='width:120px; height:120px; border: 0em; border-radius:22px' />
</a>
</div>
</div>
</div>
<div>
<p style='text-align: center'>
#{name}
</p>
</div>
</div>
</li>
                          HTML

			end

			result
    end

    def get_app_store_data(app_store_id)
      app_store_url = app_store_url_with_id(app_store_id)
      json = open(app_store_url).read

      local_file = get_local_file(app_store_id)
      File.open(local_file, "w") do |io|
        io.write json
      end

      JSON.parse(json)
    end

    # Local Copy

    def get_app_local_data(app_store_id)
      local_file = get_local_file(app_store_id)

      json = File.read local_file if File.exist? local_file
      return nil if json.nil?

      JSON.parse(json)
    end

    def get_local_file(app_store_id)
      File.join @local_folder, "#{app_store_id}.json"
    end

  end

end

Liquid::Template.register_tag('app_store_developer', Jekyll::AppstoreDevTag)

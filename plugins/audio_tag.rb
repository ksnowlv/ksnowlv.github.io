# Title:
#		Octopress HTML5 Audio Tag
#		http://antoncherkasov.me/projects/octopress-plugins
# Author:
#		Anton Cherkasov
#		http://antoncherkasov.me
#		antoncherkasov@me.com
# Syntax:
#		{% audio url/to/mp3 %}
#		{% audio url/to/mp3 url/to/ogg %}
# Example:
#		{% audio http://example.org/music.mp3 http://example.org/music.ogg %}
# Output:
#		<audio controls><source src="http://example.org/music.mp3"><source src="http://example.org/music.org"></audio>
require 'uri'

module Jekyll
	class AudioTag < Liquid::Tag
		@audio = nil

		def initialize(tag_name, markup, tokens)
			@files = markup
			super
		end

		def render(context)
			output = super
			audio = "<audio id=\"audioPlayer\" controls autoplay>"
			@files.each_line(' ') do |file|
				ext = File.extname(URI.parse(URI.encode(file.sub(" ", ""))).path).sub(".", "")
				audio += "<source id='audioPlayer_source_#{ext}' src='#{file[0...-1]}' preload='auto'>"
			end
			audio += "</audio>"
		end
	end
end

Liquid::Template.register_tag('audio', Jekyll::AudioTag)
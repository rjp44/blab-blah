# name: change-origin
# about: changes Discourse frame embedding policy and other oppotunistic stuff
# version: 0.2
# authors: Rob Pickering

register_asset "javascripts/change_origin.js"


Rails.application.config.action_dispatch.default_headers.merge!({'X-Frame-Options' => 'ALLOWALL'})


# Just because we happen to have a plugin here, lets noodle with
# Youtube onebox parms to include rel=0 & modestbranding=1
# This will need re-visiting every time onebox revs the Youtube engine
# but I'm too much of a Ruby neophyte to work out how to override the params
# initialised within embed_params without re-opening the class and copying the whole method
# ouch.
class Onebox::Engine::YoutubeOnebox
  include Onebox::Engine
  include StandardEmbed
      def embed_params
        p = {'feature' => 'oembed', 'wmode' => 'opaque', 'rel' => '0', 'modestbranding' => '1'}

        p['list'] = params['list'] if params['list']

        # Parse timestrings, and assign the result as a start= parameter
        start = nil
        if params['start']
          start = params['start']
        elsif params['t']
          start = params['t']
        elsif uri.fragment && uri.fragment.start_with?('t=')
          # referencing uri is safe here because any throws were already caught by video_id returning nil
          # remove the t= from the start
          start = uri.fragment[2..-1]
        end
        p['start'] = parse_timestring(start) if start
        p['end'] = parse_timestring params['end'] if params['end']

        # Official workaround for looping videos
        # https://developers.google.com/youtube/player_parameters#loop
        # use params.include? so that you can just add "&loop"
        if params.include? 'loop'
          p['loop'] = 1
          p['playlist'] = video_id
        end

        URI.encode_www_form(p)
      end

end

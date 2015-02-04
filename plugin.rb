# name: change-origin
# about: changes Discourse origin policy
# version: 0.1
# authors: Rob Pickering

register_asset "javascripts/change_origin.js"


Rails.application.config.action_dispatch.default_headers.merge!({'X-Frame-Options' => 'ALLOWALL'})

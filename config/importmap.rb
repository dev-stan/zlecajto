# frozen_string_literal: true

pin 'application'
pin '@hotwired/turbo-rails', to: 'turbo.min.js'
pin '@hotwired/stimulus', to: '@hotwired--stimulus.js' # @3.2.2
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js'
pin_all_from 'app/javascript/controllers', under: 'controllers'
pin '@rails/activestorage', to: 'activestorage.esm.js' # enable direct uploads for ActiveStorage
pin '@rails/actioncable', to: 'actioncable.esm.js'
pin_all_from 'app/javascript/channels', under: 'channels'

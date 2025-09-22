// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
Rails.start()
import "controllers"
// import "fontawesome"
import "@rails/ujs" 


import * as ActiveStorage from "@rails/activestorage"
ActiveStorage.start()

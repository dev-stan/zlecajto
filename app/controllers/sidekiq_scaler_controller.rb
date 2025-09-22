# app/controllers/sidekiq_scaler_controller.rb
class SidekiqScalerController < ApplicationController
  before_action :authenticate_token!

  require 'sidekiq/api'
  require 'net/http'
  require 'uri'
  require 'json'

  HEROKU_APP = ENV['HEROKU_APP']
  HEROKU_API_KEY = ENV['HEROKU_API_KEY']

  def scale
    queued_jobs = Sidekiq::Stats.new.queued
    busy_jobs   = Sidekiq::Workers.new.size

    if queued_jobs > 0 || busy_jobs > 0
      scale_worker(1)
    else
      scale_worker(0)
    end

    render json: { status: 'ok', queued: queued_jobs, busy: busy_jobs }
  end

  private

  # Scale worker dyno using Heroku Platform API
  def scale_worker(dynos)
    uri = URI.parse("https://api.heroku.com/apps/#{HEROKU_APP}/formation/worker")
    request = Net::HTTP::Patch.new(uri)
    request['Content-Type'] = 'application/json'
    request['Accept'] = 'application/vnd.heroku+json; version=3'
    request['Authorization'] = "Bearer #{HEROKU_API_KEY}"
    request.body = { quantity: dynos }.to_json

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    Rails.logger.info "Scaled worker to #{dynos} dynos. Response: #{response.code}"
  rescue StandardError => e
    Rails.logger.error "Error scaling worker: #{e.message}"
  end

  # Simple token-based authentication
  def authenticate_token!
    head :unauthorized unless params[:token] == ENV['SIDEKIQ_SCALE_TOKEN']
  end
end

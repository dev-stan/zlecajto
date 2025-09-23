# app/controllers/sidekiq_scaler_controller.rb
class SidekiqScalerController < ApplicationController
  skip_before_action :verify_authenticity_token
  # before_action :authenticate_token!  # add back for security

  require 'sidekiq/api'
  require 'net/http'
  require 'uri'
  require 'json'

  HEROKU_APP     = ENV['HEROKU_APP']
  HEROKU_API_KEY = ENV['HEROKU_API_KEY']

  def scale
    stats = Sidekiq::Stats.new
    queued_jobs = stats.queues.values.sum
    busy_jobs   = Sidekiq::Workers.new.size

    dynos_needed = queued_jobs > 0 || busy_jobs > 0 ? 1 : 0
    scale_worker(dynos_needed)

    render json: { status: 'ok', queued: queued_jobs, busy: busy_jobs, dynos: dynos_needed }
  rescue StandardError => e
    Rails.logger.error "Error in scale action: #{e.message}"
    render json: { status: 'error', message: e.message }, status: 500
  end

  private

  def scale_worker(dynos)
    formation_url = "https://api.heroku.com/apps/#{HEROKU_APP}/formation"

    # Fetch current formations
    uri = URI.parse(formation_url)
    request = Net::HTTP::Get.new(uri)
    request['Accept'] = 'application/vnd.heroku+json; version=3'
    request['Authorization'] = "Bearer #{HEROKU_API_KEY}"

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    unless response.is_a?(Net::HTTPSuccess)
      Rails.logger.error "Failed to fetch formations: #{response.code} #{response.body}"
      return
    end

    formations = JSON.parse(response.body)
    worker_exists = formations.any? { |f| f['type'] == 'worker' }

    unless worker_exists
      Rails.logger.warn 'Worker dyno not defined in Procfile. Skipping scaling.'
      return
    end

    # Scale worker
    scale_uri = URI.parse("#{formation_url}/worker")
    scale_request = Net::HTTP::Patch.new(scale_uri)
    scale_request['Content-Type'] = 'application/json'
    scale_request['Accept'] = 'application/vnd.heroku+json; version=3'
    scale_request['Authorization'] = "Bearer #{HEROKU_API_KEY}"
    scale_request.body = { quantity: dynos }.to_json

    scale_response = Net::HTTP.start(scale_uri.hostname, scale_uri.port, use_ssl: true) do |http|
      http.request(scale_request)
    end

    Rails.logger.info "Scaled worker to #{dynos} dynos. Response: #{scale_response.code}"
  rescue StandardError => e
    Rails.logger.error "Error scaling worker: #{e.message}"
  end
end

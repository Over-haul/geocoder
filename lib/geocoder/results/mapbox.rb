require 'geocoder/results/base'

module Geocoder::Result
  class Mapbox < Base

    def latitude
      @latitude ||= @data["geometry"]["coordinates"].last.to_f
    end

    def longitude
      @longitude ||= @data["geometry"]["coordinates"].first.to_f
    end

    def coordinates
      [latitude, longitude]
    end

    def place_name
      @data['text']
    end

    def street
      @data['properties']['address']
    end

    def city
      @data['context'].map { |c| c['text'] if c['id'] =~ /place/ }.compact.first
    end

    def state
      @data['context'].map { |c| c['text'] if c['id'] =~ /region/ }.compact.first
    end

    alias_method :state_code, :state

    def postal_code
      @data['context'].map { |c| c['text'] if c['id'] =~ /postcode/ }.compact.first
    end

    def country
      @data['context'].map { |c| c['text'] if c['id'] =~ /country/ }.compact.first
    end

    def country_code
      @data['context'].map { |c| c['short_code'] if c['id'] =~ /country/ }.compact.first.try(:upcase)
    end

    def neighborhood
      @data['context'].map { |c| c['text'] if c['id'] =~ /neighborhood/ }.compact.first
    end

    def address
      [place_name, street, city, state, postal_code, country].compact.join(", ")
    end

    def full_address?
      @data['id'] =~ /address/ && @data['address'].present?
    end
  end
end

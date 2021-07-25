require 'delegate'
module Twofishes
  class Result < SimpleDelegator
    def self.from_response(response)
      response.interpretations.map do |interpretation|
        new(interpretation)
      end
    end

    def self.from_bulk_response(response)
      response.interpretationIndexes.map do |indexes|
        indexes[0] && new(response.interpretations[indexes[0]])
      end
    end
  end
end

require 'forwardable'
class GeocodeInterpretation
  extend Forwardable
  def_delegators :feature, *GeocodeFeature::FIELDS.map { |_, v| v[:name] }

  def country_code
    cc
  end

  def lat
    geometry.center.lat
  end

  def lng
    geometry.center.lng
  end

  def coordinates
    [lat, lng]
  end
end

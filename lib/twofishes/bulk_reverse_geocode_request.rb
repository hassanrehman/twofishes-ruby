module Twofishes
  class BulkReverseGeocodeRequest < ::BulkReverseGeocodeRequest
    def initialize(options = {})
      options = substitute_aliases(options)
      options[:latlngs] = prepare_latlngs(options[:latlngs])
      super(options)
    end

    def prepare_ll(ll)
      case ll
      when String
        lat, lng = ll.split(/\s*,\s*/)
        new_point(lat, lng)
      when Array
        new_point(ll[0], ll[1])
      when Hash
        new_point(ll[:lat], ll[:lng])
      else
        ll
      end
    end

    def prepare_latlngs(latlngs)
      case latlngs
      when Array
        latlngs.map { |latlng| prepare_ll(latlng) }
      else
        latlngs
      end
    end

    # All params for bulk stuff, params are ::CommonGeocodeRequestParams.new as 'params'
    def substitute_aliases(options)
      options[:params] ||= {}
      ::CommonGeocodeRequestParams::FIELDS.map{|_, h| h[:name].to_sym }.each do |field_name|
        options[:params][field_name] = options.delete(field_name)
      end
      options[:params] = ::CommonGeocodeRequestParams.new(options[:params])

      options
    end

    private

    def new_point(lat, lng)
      GeocodePoint.new(lat: lat.to_f, lng: lng.to_f)
    end
  end
end

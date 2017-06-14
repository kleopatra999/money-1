class Money
  class Currency
    class UnknownCurrency < ArgumentError; end

    CURRENCY_DATA_PATH = "#{File.expand_path('../../../config', __FILE__)}/currency_iso.json"

    @@instance_lock = Mutex.new

    attr_reader :priority, :iso_code, :iso_numeric, :name, :symbol,
      :disambiguate_symbol, :html_entity, :subunit, :subunit_to_unit, :decimal_mark,
      :thousands_separator, :symbol_first, :smallest_denomination, :alternate_symbols

    class << self
      def new(currency_iso)
        iso = currency_iso.to_s.downcase
        loaded_currencies[iso] || @@instance_lock.synchronize { super(iso) }
      end

      def loaded_currencies
        @loaded_currencies ||= {}
      end

      def currencies_json
        @currencies_json ||= begin
          json = File.read(CURRENCY_DATA_PATH)
          json.force_encoding(::Encoding::UTF_8) if defined?(::Encoding)
          JSON.parse(json)
        end
      end
    end
    currencies_json

    def initialize(currency_iso)
      unless data = self.class.currencies_json[currency_iso]
        raise UnknownCurrency, "Unknown currency '#{currency_iso}'"
      end
      @id                    = currency_iso
      @alternate_symbols     = data['alternate_symbols']
      @decimal_mark          = data['decimal_mark']
      @disambiguate_symbol   = data['disambiguate_symbol']
      @html_entity           = data['html_entity']
      @iso_code              = data['iso_code']
      @iso_numeric           = data['iso_numeric']
      @name                  = data['name']
      @priority              = data['priority']
      @smallest_denomination = data['smallest_denomination']
      @subunit               = data['subunit']
      @subunit_to_unit       = data['subunit_to_unit']
      @symbol                = data['symbol']
      @symbol_first          = data['symbol_first']
      @thousands_separator   = data['thousands_separator']
      freeze
    end
  end
end

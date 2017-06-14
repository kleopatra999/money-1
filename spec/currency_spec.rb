require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Currency" do
  let(:money) { Money::Currency.new('usd') }
  let(:currency_data) {{
    "priority": 1,
    "iso_code": "USD",
    "name": "United States Dollar",
    "symbol": "$",
    "disambiguate_symbol": "US$",
    "alternate_symbols": ["US$"],
    "subunit": "Cent",
    "subunit_to_unit": 100,
    "symbol_first": true,
    "html_entity": "$",
    "decimal_mark": ".",
    "thousands_separator": ",",
    "iso_numeric": "840",
    "smallest_denomination": 1
  }}

  describe "#new" do
    it "is constructable with a uppercase string" do
      expect(Money::Currency.new('USD').iso_code).to eq('USD')
    end

    it "is constructable with a symbol" do
      expect(Money::Currency.new(:usd).iso_code).to eq('USD')
    end

    it "is constructable with a lowercase string" do
      expect(Money::Currency.new('usd').iso_code).to eq('USD')
    end

    it "has currency data accessible" do
      currency_data.keys.each do |attribute|
        expect(money.public_send(attribute)).to eq(currency_data[attribute])
      end
    end

    it "raises if the currency is invalid" do
      expect { Money::Currency.new('yyy') }.to raise_error(Money::Currency::UnknownCurrency)
    end
  end
end

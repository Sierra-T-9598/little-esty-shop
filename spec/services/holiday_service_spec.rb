require 'rails_helper'
#
# RSpec.describe HolidayService do
#   before(:each) do
#     @service = HolidayService.new
#     @mock_response = [{}, {}, {}, {}]
#     allow(HTTParty).to receive(:get).and_return(HTTParty::Response.new)
#     allow(JSON).to receive(:parse).and_return(@mock_response)
#   end
#
#   describe '#get url' do
#     it 'retrieves the API data and parses' do
#       expect(@service.get_url(mock)).to eq(@mock_response)
#     end
#   end
#
#
#   describe '#upcoming_us_holidays' do
#     it 'returns the three next US holidays' do
#       expect(@service.upcoming_us_holidays).to eq(@mock_response[0..2])
#     end
#   end
# end
# RSpec.describe HolidayService do
#   it 'returns public holiday data' do
#
#     mock_response =
#       "[{\"date\":\"2021-11-25\",\"localName\":\"Thanksgiving Day\",\"name\":\"Thanksgiving Day\",\"countryCode\":\"US\",\"fixed\":false,\"global\":true,\"counties\":null,\"launchYear\":1863,\"types\":[\"Public\"]},{\"date\":\"2021-12-24\",\"localName\":\"Christmas Day\",\"name\":\"Christmas Day\",\"countryCode\":\"US\",\"fixed\":false,\"global\":true,\"counties\":null,\"launchYear\":null,\"types\":[\"Public\"]},{\"date\":\"2021-12-31\",\"localName\":\"New Year's Day\",\"name\":\"New Year's Day\",\"countryCode\":\"US\",\"fixed\":false,\"global\":true,\"counties\":null,\"launchYear\":null,\"types\":[\"Public\"]},{\"date\":\"2022-01-17\",\"localName\":\"Martin Luther King, Jr. Day\",\"name\":\"Martin Luther King, Jr. Day\",\"countryCode\":\"US\",\"fixed\":false,\"global\":true,\"counties\":null,\"launchYear\":null,\"types\":[\"Public\"]},{\"date\":\"2022-02-21\",\"localName\":\"Presidents Day\",\"name\":\"Washington's Birthday\",\"countryCode\":\"US\",\"fixed\":false,\"global\":true,\"counties\":null,\"launchYear\":null,\"types\":[\"Public\"]},{\"date\":\"2022-04-15\",\"localName\":\"Good Friday\",\"name\":\"Good Friday\",\"countryCode\":\"US\",\"fixed\":false,\"global\":false,\"counties\":[\"US-CT\",\"US-DE\",\"US-HI\",\"US-IN\",\"US-KY\",\"US-LA\",\"US-NC\",\"US-ND\",\"US-NJ\",\"US-TN\"],\"launchYear\":null,\"types\":[\"Public\"]},{\"date\":\"2022-05-30\",\"localName\":\"Memorial Day\",\"name\":\"Memorial Day\",\"countryCode\":\"US\",\"fixed\":false,\"global\":true,\"counties\":null,\"launchYear\":null,\"types\":[\"Public\"]},{\"date\":\"2022-06-20\",\"localName\":\"Juneteenth\",\"name\":\"Juneteenth\",\"countryCode\":\"US\",\"fixed\":false,\"global\":true,\"counties\":null,\"launchYear\":2021,\"types\":[\"Public\"]},{\"date\":\"2022-07-04\",\"localName\":\"Independence Day\",\"name\":\"Independence Day\",\"countryCode\":\"US\",\"fixed\":false,\"global\":true,\"counties\":null,\"launchYear\":null,\"types\":[\"Public\"]},{\"date\":\"2022-09-05\",\"localName\":\"Labor Day\",\"name\":\"Labour Day\",\"countryCode\":\"US\",\"fixed\":false,\"global\":true,\"counties\":null,\"launchYear\":null,\"types\":[\"Public\"]},{\"date\":\"2022-10-10\",\"localName\":\"Columbus Day\",\"name\":\"Columbus Day\",\"countryCode\":\"US\",\"fixed\":false,\"global\":false,\"counties\":[\"US-AL\",\"US-AZ\",\"US-CO\",\"US-CT\",\"US-DC\",\"US-GA\",\"US-ID\",\"US-IL\",\"US-IN\",\"US-IA\",\"US-KS\",\"US-KY\",\"US-LA\",\"US-ME\",\"US-MD\",\"US-MA\",\"US-MS\",\"US-MO\",\"US-MT\",\"US-NE\",\"US-NH\",\"US-NJ\",\"US-NM\",\"US-NY\",\"US-NC\",\"US-OH\",\"US-OK\",\"US-PA\",\"US-RI\",\"US-SC\",\"US-TN\",\"US-UT\",\"US-VA\",\"US-WV\"],\"launchYear\":null,\"types\":[\"Public\"]},{\"date\":\"2022-11-11\",\"localName\":\"Veterans Day\",\"name\":\"Veterans Day\",\"countryCode\":\"US\",\"fixed\":false,\"global\":true,\"counties\":null,\"launchYear\":null,\"types\":[\"Public\"]}]"
#
#     allow_any_instance_of(HTTParty).to receive(:get).and_return(HTTParty::Response.new)
#     allow_any_instance_of(HTTParty::Response).to receive(:body).and_return(mock_response)
#     service = HolidayService.new
#
#     expect(service.upcoming_us_holidays).to eq(["Thanksgiving Day", "Christmas Day", "New Year's Day"])
#   end
# end

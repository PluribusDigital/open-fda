require 'spec_helper'

RSpec.describe "Events API" do

  before :each do 
    @lipitor_ndc = "0071-0156"
  end

  it 'sends a list of events with a valid (and popular) ndc' do
    get "/api/v1/events?product_ndc=#{@lipitor_ndc}"
    expect(response).to be_success 
    expect(json["error"]).to_not be_present
    expect(json["results"].length).to eq 10 
  end

  it 'finds no events for a fake ndc' do
    fake_ndc = "9999-2343433422-2343434234234234235555"
    get "/api/v1/events?product_ndc=#{fake_ndc}"
    expect(json["error"]).to be_present
  end

end
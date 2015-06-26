require 'spec_helper.rb'

feature "Drug Detail", js: true do

  include Requests::DrugHelpers

  before :each do 
    setup_drug_data
    sleep(5) # avoid API rate limit
  end

  scenario "basic information" do
    visit "/#/drug/#{@viagra.product_ndc}"
    expect(page).to have_content "Viagra"
    # Generic Name
    expect(page).to have_content "SILDENAFIL CITRATE"
    # Effects 
    expect(page).to have_content "PRURITUS"
  end # typeahead

  scenario "info on recalls" do
    visit "/#/drug/#{@viagra.product_ndc}" 
    expect(page).to have_content "Recalls: 0"
    visit "/#/drug/#{@advilpm.product_ndc}" 
    expect(page).to have_content "Recalls: 1"
  end # typeahead

  scenario "links to alternative drugs", smoke:true do
    visit "/#/drug/#{@viagra.product_ndc}"
    expect(page).to have_content "Viagra" 
    alts_panel = page.find('panel[panel-title="Alternative Drugs"]')
    alts_panel.find('span.glyphicon-plus-sign').click
    alts_panel.first(:link, "Revatio").click
    expect(page).to have_content "Revatio"
  end # typeahead

end 


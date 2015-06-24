require 'spec_helper.rb'

feature "Drug Detail", js: true do

  include Requests::DrugHelpers

  before :each do 
    setup_drug_data
  end

  scenario "basic information", smoke:true do
    visit "/#/drug/#{@viagra.product_ndc}"
    expect(page).to have_content "Viagra"
    # Generic Name
    expect(page).to have_content "SILDENAFIL CITRATE"
    # Effects 
    expect(page).to have_content "PRURITUS"
  end # typeahead

  scenario "info on recalls", smoke:true do
    visit "/#/drug/#{@viagra.product_ndc}" 
    expect(page).to have_content "Recalls: 0"
    visit "/#/drug/#{@advilpm.product_ndc}" 
    expect(page).to have_content "Recalls: 1"
  end # typeahead

  scenario "links to alternative drugs", smoke:true do
    visit "/#/drug/#{@viagra.product_ndc}" 
    first(:link, "Revatio").click
    expect(page).to have_content "Revatio"
  end # typeahead

end 


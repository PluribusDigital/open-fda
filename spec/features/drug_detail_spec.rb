require 'spec_helper.rb'

feature "Drug Detail", js: true do

  scenario "basic information" do
    visit '/#/drug/0069-4220' 
    expect(page).to have_content "Viagra"
    # Generic Name
    expect(page).to have_content "SILDENAFIL CITRATE"
    # Effects 
    expect(page).to have_content "DRUG INEFFECTIVE"
  end # typeahead

  scenario "info on recalls" do
    visit '/#/drug/0069-4220' 
    expect(page).to have_content "Recalls: 0"
    visit '/#/drug/0264-7800' 
    expect(page).to have_content "Recalls: 1"
  end # typeahead

  scenario "links to alternative drugs" do
    visit '/#/drug/64764-0046' 
    click_link 'AcipHex'
    expect(page).to have_content "AcipHex"
  end # typeahead

end 


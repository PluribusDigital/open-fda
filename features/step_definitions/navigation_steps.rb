Given(/^I go to the home page$/) do
  visit '/'
end

Given(/^I hit the button for "(.*?)"$/) do |button_name|
  click_on button_name
end

When(/^I select "(.*?)"$/) do |title|
  click_on title
end

Then(/^I should see the text "(.*?)"$/) do |text|
  expect(page).to have_content(text)
end

Then(/^I should NOT see the text "(.*?)"$/) do |text|
  expect(page).to_not have_content(text)
end

Given(/^I have searched for "(.*?)"$/) do |term|
  step 'I go to the home page'
  step 'I fill in keywords text box with "' + term + '"'
  step 'I hit the button for "Search"'
end
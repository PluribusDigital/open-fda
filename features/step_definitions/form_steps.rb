Given(/^I fill in (.*?) text box with "(.*?)"$/) do |field,value|
  fill_in field, with: value
end
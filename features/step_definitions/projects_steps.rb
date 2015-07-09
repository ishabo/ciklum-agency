Given /^I have projects titled: (.+)$/ do |titles|
	titles.split(', ').each do |title|
		Project.create!(:name => title)
	end
end
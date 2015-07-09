# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
require 'pp'
BonusScheme.create([
	{reason: 'Project Conversion', value: 200, key_name: 'conversion'},
	{reason: 'Sold Workshop', value: 100, key_name: 'ws'},
	{reason: 'Sold UX', value: 100, key_name: 'ux'}
])

Position.create([
	{name: 'Technical Business Consultant', has_bonus: true},
	{name: 'UX Consultant', has_bonus: false},
	{name: 'Business Analyst', has_bonus: false},
	{name: 'Engagement Manager', has_bonus: false},
	{name: 'Client Setvice Manager', has_bonus: false},
	{name: 'Reviewer', has_bonus: false},
])

ServiceType.create([
	{name: 'Workshop', key_name: 'ws'},
	{name: 'UX-UI', key_name: 'ux'},
	{name: 'PPOP', key_name: 'ppop'},
	{name: 'T&TR', key_name: 'ttr'},
	{name: 'Business Analysis', key_name: 'ba'},
])

User.create([
	{name: 'Issa Shabo', email: 'iss@ciklum.com', password: Digest::SHA1.hexdigest('123'), position: Position.find(1)},
	{name: 'Maxim Evdokimov', email: 'maev@ciklum.com', password: Digest::SHA1.hexdigest('123'), position: Position.find(1)},	
])

# 30.times do |i|
# 	project = Project.create({
# 		:name => "Project #{i}", 
# 		:client => "Client #{i}", 
# 		:description => "Bla bla #{i}", 
# 		:converted => Project.conversion_status[[:pending, :won, :lost].sample],
# 		:project_manager => "Project manager #{i}",
# 		:sales_manager => "Salesman #{i}",
# 		:status_comment => "bla",
# 		:budget => 13000,
# 		:hub_id => 1232,
# 		:engagement_type => Project.engagement_types[[:project_delivery, :rate_card, :service_only].sample],
# 		:abc => Project.client_abc.invert[['A', 'B', 'B+', 'C'].sample]
# 	})
# 	pp project.id
# 	['ux', 'ws'].each do |service_type|
# 		get_service_type =	ServiceType.find_by_key_name(service_type)
# 		service = Service.create({
# 				:project_id => project.id, 
# 				:sold_by => rand(1..2), 
# 				:user_id => rand(1..2),
# 				:duration => get_service_type.key_name == 'ux' ? [30,60,80,120].sample: [1,2,3].sample,
# 				:budget => get_service_type.key_name == 'ux' ? [1400, 2200, 3600, 4800].sample : [3000, 3500].sample,
# 				:is_paid => [false, true].sample,
# 				:status_comment => 'bla',
# 				:service_type_id => get_service_type.id,
# 				:success_status => Service.statuses[[:potential, :booked, :in_progress, :completed, :lost].sample],
# 				:start_date => rand(Date.new(2011)..Time.now.to_date).strftime("%d/%m/%Y")
			
# 		})
		
# 	end
# end
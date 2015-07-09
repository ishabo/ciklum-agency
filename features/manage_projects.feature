Feature: manage projects
	In order to create project services
	As a Technical Business Consultant
	I want create and manage projects

	Senario: projects list
		Given I have projects titled: Linkofertas, Kampster
		When I go to the list of articles
		Then I should see "Linkofertas"
		And I should see "Kampster"
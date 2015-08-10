# Ciklum Agency Project & Bonus management system

##Overview
The system was developed for an IT consultancy agency which was part of an IT provider called Ciklum. I worked for Ciklum as a Technical Business Consultant with a team of other consultants, UX designers and Business Analysts. Our work was focused on providing potential or existing clients of Ciklum with early consultancy on the software technology and architectural design, business intelligence and user experience before proceeding with development of their software. Managing those projects were tedious, especially that we had employee bonuses calculated based on specific success criteria. There was also a need to access the success rate, understanding past, current and upcoming work load for team coordination and many other factors.

The system was voluntarily developed by myself in RubyOnRails, as a proactive contribution to enhance the team work during the free time I had at work. 

## Functionality
The system serves the following functionality:

**Users:**A user management functionality to manage consultants & managers with login credentials and permissions.

**Services:** Records of services we have for each project, where a project is recorded once in the system, and at least one service is associated with it. The service can be: Workshop & Requirements Specification writing, UX-UI design or Technology & Team recommendation / proposal. The goal after successful consultancy services is to convert the project for development and pass it to the programmers and delivery team. Thus, each project had a conversion status (either potential, lost or converted), and each service had success status (potential, booked, in progress, lost, completed). 

**Bonuses:** Each service is assigned to a consultant and a sales person (who can also be the consultant), and different bonus schemes are applied to different service types and bonus-illegible activity each time a service is created or updated. Each consultant who is illegible for a bonus could see his/her potential bonuses with ability to claim them, which notifies the manager who will go through each bonus to assess credibility and validity of the bonus claim and the integrity of data. Thus, mangers can login and see the list of bonuses for each consultant that has claimed bonus payment, and then approve and have the system aggregate the details and calculate the sum of all claimed bonuses to send the result as an email to the financial department. All that is done through the system.

**Dashboard:** An overview with charts of past, current and upcoming load for each consultant, a calculation of revenue from services and project conversion, conversion rate.

The system was hosted on Heroku, only used by up to 20 people, and is no longer in use at the moment because of staff changing, changes of business strategy of the company where bonus scheme logic was completely changed, and with team growth the agency was no longer one team but split into different departments, which require a huge upgrade to the system which I wasn't available to do since I had moved on.

## Technology Stack:
**Programming lang:** RubyOnRails
**Database:** MySQL/SQLite
**Behavioural Testing:** Rspec
**Markup:** Haml/HTML
**Styling:** Sass/CSS
**Scripting:** Coffeescript/JS with jQuery
**Hosting:** Heroku

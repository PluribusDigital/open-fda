
# Administrative 
This prototype was created in response to the GSA's Request for Quotation for Agile Delivery Services (SOL#).

Company Name: **Solution Technology Systems, Inc. (STSI)**

GSA Schedule 70 Contract Number: **GS-35F-0347J** 

# Live Prototype
[drugexplorer.stsiinc.com](http:// drugexplorer.stsiinc.com/)

# Setup
[/doc/setup.md]( /docs/setup.md) has instructions to install & run the prototype.

# Approach

## Dev Stack

We use the following open source components (as well as additional plug-ins and modules)
 * PostgreSQL - Database
 * Python - ETL, specifically transformation-heavy
 * Ruby on Rails - Back End Web Application Framework
 * Bootstrap - HTML/CSS framework
 * AngularJS - Rich Client JavaScript Application Framework
 * Bootstrap.js - JavaScript widgets (as Angular Directives)
 * d3js - Charting & Visualization tools
We generally follow the style and conventions laid out in the http://angular-rails.com/ online book. 


### API Development Stack
 * Ruby on Rails - Namespaced controllers
 * jbuilder - robust templating
 * rspec request specs - integration testing of entire back end
 * Swagger - API documentation


## DevOps Stack
 * New Relic
 * CircleCI

Note: AWS vs. Heroku

### Dependency Management
We use Bundler, NPM and Bower (via bower-rails) to manage dependencies. See DEPENDENCY_README for more detail.

# Administrative Information
This application was created in response to the GSA's Request for Quotation for Agile Delivery Services.

Company Name: **Solution Technology Systems, Inc. (STSI)**

GSA Schedule 70 Contract Number: **GS-35F-0347J** 

# Approach to Create the Product

## Context & Constraints
A 24 project is different in nature than a "real", longer-lived engagement. For the purpose of this 24hr challenge exercise, we have chosen to primarily simulate the **alpha stage**, following the [18F/GOV.UK stage model](https://www.gov.uk/service-manual/phases). Our target work product is an *interactive prototype* that *illustrates functionality*. 

As in any project, we adjust the approach and prioritize tasking around the most impactful unknowns and hypotheses. For this 24hr challenge, the biggest unknown is the development capability of STSI. Therefore, we structured our work to provide the best cross-section of our approach, and the quality of our work product. In some cases, we take deliberate shortcuts - for example, with no real user community engagement, we shortcut UX activities into table-top exercises. In other cases, we do "too much", such as develop extensive testing in an immature prototype which would substantially change in direction based on user feedback. 

## Technical 

### Application Stack: Accelerated Starting Point
When we build prototypes for clients, it is foolish to start with a blank slate. We start with a shell project based largely on the [angular-rails](http://angular-rails.com/) book. The app uses a set of modern components including Ruby on Rails, AngularJS, Cucumber, and CoffeeScript. Bower manages front-end dependencies, and the Rails asset pipeline packages and serves front-end code.

![Solution Overview](/doc/solution/application_overview.png?raw=true)

### Infrastructure: Rapid Time-to-Demo
In the alpha phase, we get the most return on effort by creating application functionality. We need the ability to deploy efficiently, but the deployment platform is not critical. Therefore, we defer some of the deployment scripting work by leveraging Heroku for the time being, and focus the fastest time-to-demo possible. This is compatible with later scripting (e.g. via Chef/Puppet) deployments to other infrastructure such as AWS or in-house.

### Testing: 3-Level Suite
Testing exists at three basic levels: 
- *Full-stack Integration:* Cucumber feature specs (under `features/*.feature`) exercise the entire application, through the browser, from the perspective on an end user. The gherkin-syntax feature files facilitate collaboration with business stakeholders, while driving automated testing for developers.
- *Front-end:* Jasmine and AngularJS testing infrastructure allow us to unit-test front-end JavaScript code (under `spec/javascripts/*`).
- *Back-end API:* Rspec and Rails testing infrastructure allow us to unit test back end code, and perform integration tests for the API interactions that the front-end expects (under `spec/controllers/*`, `spec/models/*`).

## Collaboration

### Tooling: Modern Collaboration
Our team collaborates using modern tools. **Git/GitHub** manages our source code. We use **Slack** as a corporate tool for communication and chat, which also integrates with other tools (GitHub, Trello, etc.) for unified notifications. We use *Trello* to manage our feature backlog and tasking. We would consider other tooling, particularly Trello alternatives, for a longer-lived project.

### Cadence: Pomodoros & Daily Retro

### User Engagement: Daily Demos














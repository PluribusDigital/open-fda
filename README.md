
# Administrative 
This prototype was created in response to the GSA's Request for Quotation for Agile Delivery Services (SOL#).

Company Name: **Solution Technology Systems, Inc. (STSI)**

GSA Schedule 70 Contract Number: **GS-35F-0347J** 

[Licence](LICENSE.md)
# Live Prototype
[drugexplorer.stsiinc.com](http:// drugexplorer.stsiinc.com/)
# Setup
[setup.md](/doc/setup.md) has instructions to install & run the prototype.
# Approach

Staff at STSI developed the **RxExplore** prototype primarily based on openFDA data. There was lots of *great data*, with meaningful *connections* between data elements. However, the *connections were not apparent or easily accessible*.
This prototype is all about those connections. We expose connections in two big ways:
1.	Combining information about any given drug into a comprehensive detail page, including data from openFDA, but also other FDA and external sources.
2.	Exploring connections through a tree visualization tool.
## Process
### Iterative Solution Development
We mirrored the Discovery-Beta phases of the [18F/UK.gov]( https://18f.gsa.gov/dashboard/stages/) model:

**Discovery**: 
On Wednesday (Day 1), we brainstormed the solution, bouncing between mind-maping possible customer/value propositions, developing customer personas, testing data availability by playing with API queries, and some customer validation (we interviewed two pharmacists for feedback on initial ideas). The goal was to settle on a value proposition and high-level solution.

![Discovery Process](/doc/solution/discovery.png?raw=true) 
 
**Alpha**: 
By Thursday, we started wiring up the prototype. At day’s end we had our first demo with our stand-in customer (from the office). We used that feedback to prioritize backlog items and shape the solution design. 

_**The Vision Materializes...** ~ With feedback on Thursday and Friday, we had started to crystallize on a vision of “connections”. From both a technical and UX standpoint, current data was theoretically connected, but those connections were not explicit. We set our vision on showing **connections across drugs**_

**Beta**: 
With the direction set, and a solid feature backlog, we started the real engineering. We worked to integrate data sources, and bring those together in a cohesive application that could be launched.

### Team Dynamic
The team consisted of 4 staff, 2 fulltime and 2 part-time. There were areas of leadership, but most contributed across the board:
* _Lead & Developer_ – Full responsibility and authority to marshal resources, and accountability for creating a great product; led backend coding.
* _Architect & Developer_ – Owned overall solution quality; wrote frontend and backend code.
* _DevOps Lead_ – Led DevOps/CI solution, established environments, etc.
* _Frontend Developer_ – Designed user-facing pages; developed just-enough UX artifacts; analyzed source data.

We had 2-3 compressed standup meetings each day to stay coordinated on the tight schedule, and reprioritized the backlog daily. 

We limited working hours to a sustainable pace (8 hour days). Our [punch card]( /graphs/punch-card) shows this, with the exception of some DevOps work that was done late – in part for personal preference, and in part to not disrupt the CI process.
### Collaboration Tools
* **Git/GitHub**: manages source code. 
* **Slack**: corporate chat tool, which integrates with GitHub, Trello, CircleCI, New Relic, etc. for unified notifications. 
* **Trello**: manage feature backlog/tasking. 

## Technical Solution
We used STSI’s [hello]( https://github.com/STSILABS/hello) project as a starting point framework. With extensive data transformation, we added python ETL scripts.
The below diagram provides an overview of the major parts of the application. Starting bottom-left:
* Import external data via batch processes – simple processes done in Ruby, and complex transformations done in Python scripts.
* Store data using PostgreSQL tables managed by Rails/ActiveRecord migrations.
* Serve backend API and frontend assets via Ruby on Rails application
    * _Calls to api.fda.gov are cached in an hstore (key/value) field, minimizing processing delays and reducing load on the API_
* Provide a rich client experience, built on AngularJS along with D3js directives for visualizations
* Cover modules with unit tests, and provide integration testing around key interfaces (browser, internal RxExplore API, consumed APIs).

![Solution Overview](/doc/solution/application_overview.png?raw=true)

We were able to rapidly create this prototype, in large part because of the many high-quality, freely available open source components available, such as:
•	AngularJS - JavaScript rich-client front-end application framework
•	Bootstrap - HTML/CSS/JavaScript framework
•	D3.js - interactive data-driven visualizations
•	Swagger - API documentation
•	Ruby on Rails - back-end web application framework built on the Ruby programming language
•	Python - flexible programming language used here to import and transform data
•	PostgreSQL - database
We generally follow the style and conventions laid out in the (very well done) Angular Rails online book by David Bryant Copeland.

## Deployment & DevOps Stack
 
We streamline development with a solid DevOps pipeline.  Developers modify the app locally and push to GitHub. A push triggers CircleCI to grab the code and execute per the circle.yml file. It builds a server from the Dockerfile, then installs dependencies (see [doc/dependency_management](doc/ dependency_management.md) ). CircleCI finally runs tests. 

If all steps pass, CircleCI deploys the docker image. AWS Elastic Beanstalk listens for new docker images with the appropriate label, and installs the new image – bringing in application secrets from an S3 bucket.

![DevOps Overview](/doc/solution/devops.png?raw=true)









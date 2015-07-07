

Live Prototype URL: [RxExplore.com](http://rxexplore.com/) 

Evaluation Branch: please use the [eval](https://github.com/STSILABS/open-fda/tree/eval) branch for BPA evaluation purposes.

[License](LICENSE.md)

# Setup

[/doc/setup.md](/doc/setup.md) has instructions to install & run the prototype.

# Approach

**RxExplore** is primarily based on openFDA data - which has *great data*. However, *connections were not apparent or easily accessible*. This prototype is about exposing those connections in two big ways:

1. **Combining** information about any given drug into a comprehensive detail page, including data from openFDA and other government sources.

2.	**Exploring** connections through a tree visualization.

_See the [prototype's About page](http://www.rxexplore.com/#/about) for more._

## Process

### Iterative Solution Development
We mirrored the Discovery-Beta phases of the [18F/UK.gov](https://18f.gsa.gov/dashboard/stages/) model:

**Discovery**: 
On Wednesday (Day 1), we brainstormed the solution. As a Development Pool submission, we wanted at least a minimal set of [UX artifacts](https://github.com/STSILABS/open-fda/tree/eval/doc/design_artifacts) to guide us. Brainstorming bounced between mind-mapping possible customer/value propositions, developing customer personas, testing ideas against API queries, and some customer validation (we interviewed two pharmacists for feedback on initial ideas).  We settled on a value proposition and high-level solution.

![Discovery Process](/doc/solution/discovery.png?raw=true) 
 
**Alpha**: 
By Thursday, we started building the prototype. At day’s end, we had our first demo with our stand-in customer. We used that feedback to prioritize backlog items and shape the solution design. 

_**The Vision Crystalizes...** ~ With feedback on Thursday and Friday, we settled on a vision of “connections”. From both a technical and UX standpoint, current data was theoretically connected, but those connections were not explicit. We set our vision on showing **connections across drugs**._

**Beta**: 
With the direction set, and a solid feature backlog, we started the real engineering. We integrated data sources, bringing them together in a cohesive, public-ready application.

![Beta Development Process](/doc/solution/development_whiteboard.png?raw=true) 

### Team Dynamic
The team consisted of 4 staff, 2 fulltime and 2 part-time for approximately 10 working days. There were areas of leadership, but most contributed across the board:
* _Lead/Backend Web Developer_ – Full responsibility and authority to marshal resources, and accountability for creating a great product; led backend coding.
* _Technical Architect_ – Owned overall solution quality; wrote frontend and backend code.
* _DevOps Engineer_ – Led DevOps/CI solution, established environments, etc.
* _Frontend Web Developer_ – Designed user-facing pages; developed UX artifacts; analyzed source data.

We had 2-3 compressed standup meetings each day to stay coordinated, and reprioritized the backlog daily. 

We limited working hours to a sustainable pace (8 hour days). Our [punch card](https://github.com/STSILABS/open-fda/graphs/punch-card) shows this, with the exception of some DevOps work that was done late (in part for personal preference and in part not to disrupt the development process).

### Collaboration Tools
* **Trello**: backlog/tasking. 
* **Slack**: corporate chat tool, integrated with GitHub, Trello, CircleCI, New Relic, etc. for unified notifications. 

### More...
We have placed all associated documentation within the `/doc/` directory.

## Technical Solution

We used STSI’s [hello]( https://github.com/STSILABS/hello) project, a kind of boilerplate app we use for prototyping. We added on python ETL scripts to build maps between data elements, and other technical elements as neccessary.

The below diagram provides an overview of the major parts of the application. Starting bottom-left:
* Import external data via batch processes – simple processes done in Ruby, and complex transformations done in Python scripts.
* Store data using PostgreSQL tables managed by Rails/ActiveRecord migrations.
* Serve backend API and frontend assets via Ruby on Rails application
    * _Calls to api.fda.gov are cached in an hstore (key/value) field, minimizing processing delays and reducing load on the API_
    * _Other screen-scraped or imported data (drug shortages, etc.) are also stored in the same style hstore field_
* Provide a rich client experience, built on AngularJS along with D3js directives for visualizations
* Cover modules with unit tests, and provide integration testing around key interfaces (browser, internal RxExplore API, consumed APIs). 
    * _See [testing strategy](/doc/testing.md) for more detail._

![Solution Overview](/doc/solution/application_overview.png?raw=true)

We were able to create this prototype rapidly, in large part because of the many high-quality, freely available open source components available. See [THANKS.md](THANKS.md) for more.

## Deployment & DevOps Stack
 
We streamline development with a DevOps pipeline, pictured below. 

1. Developers modify the app locally and push to GitHub (source control/configuration management). 
2. A push triggers CircleCI to grab the code and execute steps per the `circle.yml` file.  This includes:
  1. Building a server from the `Dockerfile`
  2. Installing all dependencies (see [doc/dependency_management](doc/dependency_management.md) ). 
  3. Building the database
  4. Running all tests.
3. If all steps pass, CircleCI deploys the docker image. 
4. CircleCI pushes a new application to AWS Elastic Beanstalk referencing the newly built docker image.  Beanstalk launches the application – bringing in application secrets from an S3 bucket.
5. New Relic supports continuous monitoring, tracking performance issues, errors, etc.
6. Alerts are sent via Slack and/or email to notify developers of issues.

![DevOps Overview](/doc/solution/devops.png?raw=true)

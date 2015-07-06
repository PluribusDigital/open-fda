# Testing Strategy

Testing is a key part of our development process which allows us to maintain a rapid development pace over time. We cover meaningful internal functionality via unit tests, and cover the 3 primary system boundary points (see also below diagram): 1) consuming data from other APIs; 2) the web api between the frontend and backend; and 3) the user experience via the browser.

*Python Unit Tests:* in `gruve/tests`. The foundational classes for the ETL operations are unit tested using Python's unittest framework. 

*Ruby Unit Tests:* in `spec/controllers`, `spec/models` and `spec/services`. We test class behavior using rspec. We do not test frameworks. For example, vanilla Rails controllers or ActiveRecord models are not unit tested. (But controllers and the entire backend stack are covered in API integration specs).

*JavaScript Unit Tests:* in `spec/javascripts`. We test JavaScript code using jasmine supported by angular-mocks. Our primary goal is to cover the meaningful events handled by angular controllers and services.

*API Integration Specs:* in `spec/requests`. We exercise the full backend stack through request specs hitting the internal APIs. This

*Full Stack Integration Tests:* in `spec/features`. We exercise the full stack, including the browser, via a small set of feature specs. This provides a smoke test, capturing failures if any part of the stack should be broken (live calls to other APIs, database queries, internal API errors, JavaScript errors, fundamental HTML rendering issues).

![Solution Overview](/doc/solution/application_overview.png?raw=true)

## Setup

To setup this project on your local machine run:

    bundle install

and

    bundle exec rake setup

That will install the required gems and run the setup test to create the test user if it isn't already created.


## Running the tests

To run the tests run:

    bundle exec rake test


## Config for local

Right now the tests are set to run against nibley.deseretbook.com.

If you want to point at a different url, you can change the base_url method in the test_helper file.

### TODO

* Centralize the user information to one place.
* Centralize credit card information to one place.
* Centralize credit card form entry to one method.
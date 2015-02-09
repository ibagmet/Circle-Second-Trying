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

* Replace explicit references to input element IDs and Names with references through the associated labels.
* Centralize registered user information to one place.
* Centralize guest user information to one place.
* Centralize credit card information to one place.
* Centralize credit card form entry to one method.
* Centralize gift card form entry to one method.
* Replace the loops in the tests with individual examples (have to find a way to keep the browser open between examples).
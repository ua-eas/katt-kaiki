Kaiki
=======

Introduction
------------

Kaiki contains Cucumber scenarios and steps that use Capybara (a thick wrapper
for the Selenium-WebDriver) to interract with a Firefox web browser
so that test cases can be run against Kuali web sites, implemented by the
University of Arizona.


Compatibility
-------------

Kaiki is tested on the following platforms:

* ruby-1.9.3p448
* Linux (specifically Crunchbang 11 based on Debian 7)


Current Capabilities
--------------------

These are a few of the current capabilities of the Kaiki framework.

* Click a portal link
  - (`When I click the "Vendor" portal link`)
* Click a button
  - (`When I click the "save" button`)
* Perform a lookup
  - (`When I start a lookup for "Building"`)
* Return a result from a search
  - (`When I return the first result`)
* Fill out a field
  - (`When I set the "Vendor Name" to "Micron"`)
* Verify a field contains certain text
  - (`Then I should see "Start Date" set to "11/11/11"`)
* Verify that a certain message appears on the screen
  - (`Then I should see the message "Document was successfully submitted"`)
* Change focus to new windows
* Close all extra, unused windows that are not the first window
* Record video when tests are run using a headless browser
* Automatically screenshot a point of failure
* Log every click and attempt to find an element for debugging purposes
* Highlight page elements during a scenario with javascript
* Speed up, slow down, pause scenarios
* Integrate into your CI


Installation
------------

This is not a gem yet. So... just clone this repository for now.
After you close the repository, you will need to run this to install
the required gems:

```gherkin
bundle install
```

Next, you will need to have Ffmpeg to generate screen shots and Xvfb
to run headless mode. They can be installed on Debian flavors of linux
like this:

```gherkin
sudo apt-get install ffmpeg
sudo apt-get install xvfb
```

File Structure
--------------
This is how the file structure needs to be set up to properly run any of the
kuali system's features from your <base folder>.

  **Notice: The features that currently work in the page object implementation
    of the Kaiki framework are included with the framework. They have altered
    verbiage compared to the original features and will not work with the
    original framework.**
```
<base folder>-
              |
              |- features-
              |           |- downloads
              |           |- kuali-coeus            (KC feature files)
              |           |- kuali-financial-system (KFS feature files)
              |           |- logs
              |           |- reports
              |           |- screenshots
              |           |- step_definitions
              |           |- support
              |           |- videos
              |
              |- lib-
              |      |- kaiki
              |      |- kaiki_pages-
              |      |              |- kc_pages  (KC page class files)
              |      |              |- kfs_pages (KFS page class files)
              |      |
              |      |- approximations_factory.rb
              |      |- ffmpeg_factory.rb
              |      |- file.rb
              |      |- kaiki.rb
              |      |- page_factory.rb
              |      |- string.rb
              |
              |- apps.json
              |- ChangeLog.txt
              |- cuke-runner.sh
              |- envs.json
              |- Gemfile
              |- LICENSE.md
              |- Rakefile
              |- README.md
              |- selenium-server.jar
              |- tail_log.rb
```

Execution Path
--------------
There are multiple ways to kick off the cucumber tests using this framework,
but they will all follow the same steps to actually execute the test.

The easiest way to kick off a test is to run a simple command such as:
```cucumber
cucumber --tags <feature or scenario tag>
```

But other commands such as:
```cucumber
cucumber features/kuali-coeus/<test>.rb -r features
```
will work just as well.

After the test is kicked off, these steps are followed:
* env.rb is executed (in /features/support/)
  - Checks apps.json to see if the user's chosen application is valid.
  - Creates an instance of the Capybara driver (Kaiki::CapybaraDriver::Base)
    corresponding to the user's chosen application.
  - Creates an instance of the Search Page object (Kaiki::Search_Page::Base)
    for use with all applications.
  - Lastly the KaikiWorld object is created to actually get the ball rolling.
* Before hooks in env.rb are executed
  - recorded_numbers.yaml is read in
  - video is started for headless tests that are not a Batch test
* Steps are then executed in order according to cucumber's rules
* When the step `When I am on the <page_name> page` is run, the create_page
  method in PageFactory is executed.
  This creates an instance of the object that matches the specified <page_name>
  from the feature file.
  **i.e. `When I am on the "Proposal" page` will create an instance of
    the Proposal class**
* Each step definition will either make a call to the current_page object or
  search_page object; very few of them do any of the "grunt" work themselves,
  all of the heavy code is held within the object classes.


Contributing
------------

Please do! Contributing is easy in Kaiki. Please read the CONTRIBUTING.md
document for more info. ... When that file exists.


Usage
-----

For now, this is incredibly specific to UA and our Jenkins box.
Here are some files that you will need to create:

### `shared_passwords.yaml`

At UA, we have a lot of test users with a shared password, and the user names
have a shared prefix. So let's say your institution works the same way,
and your test users are test-user1, test-user2, test-user3, etc. And let's say
they all share the password "some-password". Then you can take advantage of
shared passwords by writing the following `shared_passwords.yaml`:

```yaml
---
test-user: some-password
```

Then you can `export KAIKI_NETID=test-user1` and that user will be used
as the original log in. (See ff-13.0.1_env)

### Rakefile Requirements

* `rake (10.1.0, 0.9.2.2)` should be installed to run rake tasks.
* There are 3 main rake tasks currently in use, `rake KC`, `rake KFS`, and
  `rake by_tag[@tag]`.
  In order they do what you might think:
  - `rake KC`, runs all of the KC features by tag.
  - `rake KFS`, runs all of the KFS features by tag.
  - `rake by_tag[@tag]`, will run any test(s) with the tag "@tag".
  **The specific tags for KC and KFS are held in `features/support/test_tags.rb`**
* Tag names need to be added to the first line of each feature file.
* Tag names can also be added to specific scenarios if you wish to run them
  individually; such as with the KFS suites.

### Other Requirements

* `bundle install` should install all requirements.
* This is hardcoded that we used CAS.
* Look at `features/support/env.rb` for various environment variables that
  can be used.
* `envs.json` is a way to store environment names and use them in tests.
  A lot of this is hardcoded U of A stuff.
* On Linux systems, the xvfb package allows the Headless gem to do its thing.


Versioning
----------

Kaiki follows [Semantic Versioning](http://semver.org/)
(at least approximately) version 2.0.0-rc1.

License
-------

Please see [LICENSE.md](LICENSE.md)


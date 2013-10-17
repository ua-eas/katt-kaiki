Kaiki
=======

Introduction
------------

Kaiki contains Cucumber scenarios and steps that use Capybara (a thick wrapper for the Selenium-WebDriver) to interract
with a Firefox web browser so that test cases can be run against Kuali web sites.


Compatibility
-------------

Kaiki is tested on the following platforms:

* **ruby-1.9.3** on **Linux**


Current Capabilities
--------------------

These are a few of the current capabilities of the Kaiki framework.

* Click a portal link (`When I click the "Vendor" portal link`)
* Perform a lookup (`When I start a lookup for "Building"`)
* Return a result (`When I return the first result`)
* Fill out a field (`When I set the "Vendor Name" to "Micron"`)
* Fill out a field with a fuzzy, timestamped value (`When I set the "Description" to something like "testing KFSI-1021"`)
* Verify that a document was successfully submitted (`Then I should see "Document was successfully submitted"`)
* Verify that some text is on the screen (`Then I should see "AdHoc Requests have been sent`)
* Record Video
* Automatically screenshot a point of failure
* Log every click and attempt to find an element
* Find fields by their "label" (even if it is not a real HTML &lt;label&gt;)
* Highlighting page elements during a scenario with javascript
* Speed up, slow down, pause scenarios
* Integrate into your CI


Installation
------------

This is not a gem yet. So... just clone this repository for now. After you close the repository, you will need to run this to install the required gems:

```gherkin
bundle install
```

Next, you will need to have Ffmpeg to generate screen shots and Xvfb to run headless mode. They can be installed on Debian flavors of linux like this:

```gherkin
sudo apt-get install ffmpeg
sudo apt-get install xvfb
```


Contributing
------------

Please do! Contributing is easy in Kaiki. Please read the CONTRIBUTING.md document for more info. ... When that file exists.


Usage
-----

For now, this is incredibly specific to (a) UA, and (b) my laptop and our Jenkins box. Here are some files that you will need to create:

### `shared_passwords.yaml`

At UA, we have a lot of test users with a shared password, and the user names have a shared prefix. So let's say your institution works the same way, and your test users are test-user1, test-user2, test-user3, etc. And let's say they all share the password "some-password". Then you can take advantage of shared passwords by writing the following `shared_passwords.yaml`:

```yaml
---
test-user: some-password
```

Then you can `export KAIKI_NETID=test-user1` and that user will be used as the original log in. (See ff-13.0.1_env)

### `config/accounts.yaml`

There are a few steps in `features/step_definitions/login_steps.rb` that take advantage of configure files, where you can specify various roles. As an example, if you fill out `config/accounts.yaml` to look like:

```yaml
---
1089999:
  account_number: 1089999
  account_name: SIERRA CAMPUS
  fiscal_officer: jdoe
```

Then you can use a step in a scenario like so:

```gherkin
When I backdoor as the fiscal officer
```

You can also specify global roles in `config/arizona_teams.yaml` (or rename, and rename in the code):

```yaml
---
ua_fso_fm_team_451:
  name: ua_fso_fm_team_451
  user: test-user2
```

And use:

```gherkin
When I backdoor as the UA FSO FM Team 451
```

### Other Requirements

* `bundle install` should install all requirements.
* This is hardcoded that we used CAS.
* Look at `features/support/env.rb` for various environment variables that can be used.
* `envs.json` is a way to store environment names and use them in tests. A lot of this is hardcoded U of A stuff.
* On Linux systems, the xvfb package allows the Headless gem to do its thing.
* Look at `ff-13.0.1_env` for examples of how I set up my environment to be headless.


### Rakefile Requirements

* `rake (10.1.0, 0.9.2.2)` should be installed to run rake tasks.
* `--tags` are used to call some rake tasks, `@kctest` is for tests that dont need to be run in order.
* The tags need to be added to line one of each feature file.
* An ECE.rb file with an array of tags is stored in the `katt-kaiki/features/support/`, this is used to run certain features files in order.
* The rake task: `rake run` can be used to run everything in order.


Versioning
----------

Kaiki follows [Semantic Versioning](http://semver.org/) (at least approximately) version 2.0.0-rc1.

License
-------

Please see [LICENSE.md](LICENSE.md)


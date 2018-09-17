# Pivotal Tracker: Planning Poker

[![Build Status](https://travis-ci.org/adnanhemani/planning-poker.svg?branch=master)](https://travis-ci.org/adnanhemani/planning-poker)
[![Maintainability](https://api.codeclimate.com/v1/badges/af3efb99eb0cb6945f19/maintainability)](https://codeclimate.com/github/adnanhemani/planning-poker/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/af3efb99eb0cb6945f19/test_coverage)](https://codeclimate.com/github/adnanhemani/planning-poker/test_coverage)

Planning poker, also called Scrum poker, is a consensus-based technique for estimating, mostly used to estimate effort or relative size of user stories in software development. In planning poker, members of the group make estimates by playing numbered cards in the app, instead of speaking them aloud. The cards are revealed, and the estimates are then discussed. By hiding the figures in this way, the group can avoid the cognitive bias of anchoring, where the first number spoken aloud sets a precedent for subsequent estimates.

## Features
* Authentication from Pivotal Tracker
* Displays all user's projects in Pivotal Tracker
* Push Notifications when playing cards
* Bootstrap + Font-Awesome for Responsive Design

## Dependencies
* Ruby 2.1.3
* Twitter Bootstrap
* Font-Awesome
* Pivotal Tracker gem (currently v3)
* Thin webserver for Faye
* Faye for Push Notifications

## Frameworks
This application uses the following frameworks:

* [Ruby on Rails](http://rubyonrails.org/) (4.2.5.1)
* [Twitter Bootstrap](http://twitter.github.com/bootstrap/) (Front-end)
* [jQuery](http://jquery.com/) (Javascript)

## Gems
This application uses the following gems:

* [Pivotal Tracker](https://github.com/jsmestad/pivotal-tracker) (Pivotal Tracker gem)
* [Faye](http://faye.jcoglan.com/) (Faye)
* [Twitter Bootstrap SASS](https://github.com/twbs/bootstrap-sass) (Twitter Bootstrap port to SASS)
* [Font-Awesome](https://github.com/bokmann/font-awesome-rails) (Font-Awesome Rails)
* [BackTop](https://github.com/bimovidia/backtop) (Back To Top functionality)

## Getting Started

Planning Poker uses push notification with Faye. There are configuration files for each environments in config/environments:

    config.publisher = {
      # production faye server - change the URL so that it points to the correct server.
      domain: 'localhost:9292',
      # secret key
      secret: 'secret'
    }

Change the domain into the actual production domain when deploying the app. You might want to change the secret key as well. 

To get started, clone this repository to your local machine, and install dependencies:

```shell
git clone git@github.com:bimovidia/planning-poker.git
cd planning-poker
bundle install
```

Open a new terminal and start the faye server:

```shell
rackup faye.ru -s thin -E production -p 9292
```

Run the application locally with:

```shell
rails s
```

## Rule of the Game
Once you have the application set up, you can:

* Login using your Pivotal Tracker credential
* Click any project name in the header menu that has unestimated stories
* Click on **UNESTIMATED** in the submenu to see the list of unestimated stories for that project
* Click / Expand the story to start the planning poker session

Each estimator can select any point depending on the story scale point setting in pivotal tracker. The values represent the number of story points, ideal days, or other units in which the team agrees to estimate.

The estimators discuss the feature, asking questions of the product owner as needed. When the feature has been fully discussed, each estimator privately selects one card to represent his or her estimate.

Once all selections are in, any estimator can then hit the **REVEAL** button to reveal the cards at the same time.

If all estimators selected the same value, that becomes the estimate. If not, the estimators discuss their estimates. The high and low estimators should especially share their reasons. After further discussion, once the estimation score has been agreed on, any estimator can then click on any card representing that number. After that, any user can update the story name and description (if necessary) and then hit **SAVE** to update the story in Pivotal Tracker.

## Contributing
Contributions are encouraged. You can contribute in many ways. For example, you might:

* add documentation and "how-to" articles to the README or Wiki
* create an extension that provides additional functionality above and beyond Planning Poker itself
* fix bugs you've found in the Issue Tracker or improve / add new features to Planning Poker

When contributing, you will need to:

* follow the same style / convention used throughout the app (as much as you can)
* make sure your codes are well-tested and reviewed
* when fixing a bug, provide a failing test case that your patch solves
* provide proper documentation when necessary

## Google Hangouts Link Addendum
When the user wants to create an associated Google Hangout, they will click a link in the project page to do so. When they have clicked this link, we will asynchronously create a Google Meet link for them that they can use - this link will be the same for anyone accessing the same project. We will store this link for anyone that accesses this project's page on our app. Once a user requests a Google Meet link this link will be dedicated for their project permanently (as Google does not delete their links). In addition, we will have a locking mechanism when clicking on the link to prevent a TOCTTOU.

There will be one new controller method that will be in charge of this - mostly everything else will stay the same. We will also have one new db table that will keep track of locks and one new db table to keep track of the mapping of Google Meet links to Tracker projects.

## Copyright

Planning Poker is licensed under the [MIT License](http://opensource.org/licenses/mit-license.html)

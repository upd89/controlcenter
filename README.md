# README

## upd89 ControlCenter

upd89 is a system update management for debian based systems.

## Dependencies

This application is based on "Ruby on Rails" (RoR).

Tested environment:
- ruby-2.2.3
- Rails 4.2.4
- passenger 5.0.27 / Apache/2.4.7 (Ubuntu 14.04)
- postgresql-9.3

If you don't have a recent version of RoR, please have a look at the following installation guides:

- [Setup Ruby On Rails on Ubuntu][1]
  [1]: https://gorails.com/setup/ubuntu/16.10
- [How To Deploy a Rails App with Passenger and Apache on Ubuntu 14.04][2]
  [2]: https://www.digitalocean.com/community/tutorials/how-to-deploy-a-rails-app-with-passenger-and-apache-on-ubuntu-14-04


## Installation

	git clone https://github.com/upd89/controlcenter
	cd controlcenter
	bundle install
	rake db:create
	rake db:migrate
	rake db:base_data


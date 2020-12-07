<p align="center">
    <a href="https://outpost-staging.herokuapp.com/">
        <img src="https://github.com/wearefuturegov/outpost/blob/master/app/assets/images/outpost.png?raw=true" width="350px" />               
    </a>
</p>
  
<p align="center">
    <em>Service directories done right</em>         
</p>

---

<p align="center">
   <img src="https://github.com/wearefuturegov/outpost/raw/master/public/examples.jpg?raw=true" width="750px" />     
</p>

<p align="center">
    <em>Example screens from the app</em>         
</p>

---

[![Run tests](https://github.com/wearefuturegov/outpost/workflows/Run%20tests/badge.svg)](https://github.com/wearefuturegov/outpost/actions)

**[Staging site here](https://outpost-staging.herokuapp.com/)**

A [standards-driven](https://opencommunity.org.uk/) API and comprehensive set of admin tools for managing records about local community services, groups and activities.

Outpost works alongside a [seperate API component](https://github.com/wearefuturegov/outpost-api-service/).

We're also building an [example front-end](https://github.com/wearefuturegov/scout-x) for Outpost.

## 🧱 How it's built

It's a Rails app backed by a postgres database. It can also act as an OAuth provider via [Doorkeeper](https://github.com/doorkeeper-gem/doorkeeper).


## 💻 Running it locally

You need ruby and node.js installed, plus PostgreSQL server running.

If you want to build a public index for the API, you'll also need a local MongoDB server.

First, clone the repo. Then:

```
bundle install
npm install
rails db:setup
rails s

# run end-to-end and unit tests
rake
```

For the database seed to succeed, you need several source CSV data files in the `/lib/seeds` folder.

### With Docker

With [docker-compose](https://docs.docker.com/compose/) and [docker](https://www.docker.com/), after cloning the project:

- Bring up the databases with `docker-compose up`
- Populate your environment variables
- Run the application with `rails s`

### Building a public index

Outpost's API component relies on a public index stored on MongoDB.

You can run `rails build_public_index` to build the public index for the first time. Active record callbacks keep it up to date as services are changed.

In production, it's a good idea to occasionally refresh the index by running that rake task on a schedule.

## 🗓 Administrative tasks

Outpost depends on on several important [`rake`](https://guides.rubyonrails.org/v3.2/command_line.html) tasks.

Some of these can be run manually, and some are best scheduled using [Heroku Scheduler](https://devcenter.heroku.com/articles/scheduler) or similar.

| Task                              | Description                                                                        | Suggested schedule |
|-----------------------------------|------------------------------------------------------------------------------------|--------------------|
| \`build\_public\_index`           | Build the initial public index for the API service to use\.                        | One\-off           |
| \`process\_permanent\_deletions`  | Permanently delete any services that have been "discarded" for more than 30 days\. | Weekly             |
| \`ofsted\_create\_initial\_items` | Build the initial Ofsted items table                                               | One\-off           |
| \`ofsted\_update\_items`          | Check for any changes to Ofsted items against the Ofsted API                       | Daily, overnight   |


## 🌎 Running it on the web

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](
https://heroku.com/deploy)

It's suitable for 12-factor app hosting like [Heroku](http://heroku.com).

It has a `Procfile` that will [automatically run](https://devcenter.heroku.com/articles/release-phase) pending rails migrations on every deploy, to reduce downtime.

## 🧬 Configuration

It needs the following extra environment variables to be set:

- `GOOGLE_API_KEY` with the geocoding API enabled, to geocode postcodes
- `GOOGLE_CLIENT_KEY` with the javascript and static maps APIs enabled, to add map views to admin screens
- `OFSTED_API_KEY` to access the feed of Ofsted items

In production only:

- `SENDGRID_API_KEY` to send emails
- `MAILER_HOST` where the app lives on the web, to correctly form urls in emails
- `MAILER_FROM` the email address emails will be delivered from
- `FEEDBACK_FORM_URL` a form where users can submit feedback about the website

## 🔐 OAuth provider

Outpost can work as an identity provider for other apps. Users with the highest permissions can access the `/oauth/applications` route to create credentials.

Once authenticated, consumer apps can fetch information about the currently logged in user with the `/api/v1/me` endpoint.

## 🧪 Tests

It has some rspec and cucumber tests on key functionality. Run them with: 

```
rake
```

See the [full docs](https://github.com/wearefuturegov/outpost/tree/master/features).
<div align="center">
  <a href="https://store.elementary.io" align="center">
    <center align="center">
      <img src="assets/static/elementary.svg" alt="elementary" align="center">
    </center>
  </a>
  <br>
  <h1 align="center"><center>Store</center></h1>
  <h3 align="center"><center>The elementary OS merch store website</center></h3>
  <br>
  <br>
</div>

<p align="center">
  <img src="https://github.com/elementary/store/workflows/Publish/badge.svg" alt="Publish">
  <img src="https://github.com/elementary/store/workflows/Update/badge.svg" alt="Update">
</p>

---

This repository is an elixir website for `https://store.elementary.io`. It
connects to Printful for products, and Stripe for payment processing.

## Running

This repository contains a `docker-compose.yml` file for easier development.
Make sure you have `docker-compose` installed, then run these commands:

1) `docker-compose build` to build the containers. If you make changes to any
dependencies, or are getting issues where code does not seem to update, re-run
this step.

2) `docker-compose up` to start the server and dependencies. This is your main
command and after you run steps 1 and 2, you should only need to run this
command to get back up and running.

3) For the store to work and display products, you must add your Printful API
key to your `config/dev.secret.exs` file like so:

```ex
import Config

config :store, Printful.Api,
  api_key: "aaaaaaaa-bbbb-cccc:dddd-eeeeeeeeeeee"
```

You will need to restart `docker-compose up` for this to take effect

## Translations

All translations are extracted to the template files when new commits are
pushed to master. If you would like to help translate this site, please see the
[elementary weblate instance](https://l10n.elementary.io/).

## Deploying

This repository is setup with continuous integration and deployment. If you want
to deploy your changes, all you need to do is open a PR to the master branch.
Once your PR is accepted and merged in, it will automatically be deployed.

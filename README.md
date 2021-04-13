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

## Developing on elementary OS (or Ubuntu)

This guide assumes elementary OS 6 or Ubuntu 20.04; the steps should be similar for any Ubuntu-based OS, but may differ bassed on the exact distribution or version.

1. **Install Docker**

   You can install Docker however you'd like, but we recommend following [this DigitalOcean guide](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04), including adding your user to the `docker` group.

2. **Install `docker-compose`**

   Similarly, you can install docker-compose however you see fit, but the fastest way is probably via Python's `pip`:

   1. `sudo apt install python3-pip`
   2. `pip3 install docker-compose`

That's it, you're all set to start contributing.

## Running

This repository contains a `docker-compose.yml` file for easier development.
Make sure you have `docker-compose` installed, then run these commands:

1) `docker-compose build` to build the containers. If you make changes to any
dependencies, or are getting issues where code does not seem to update, re-run
this step.

2) `docker-compose up` to start the server and dependencies. This is your main
command and after you run steps 1 and 2, you should only need to run this
command to get back up and running.

3) **OPTIONAL** If you have access to a printful account, you can add the API
key to your `config/dev.secret.exs` file like so:

```ex
import Config

config :store, Elementary.Store.Printful,
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

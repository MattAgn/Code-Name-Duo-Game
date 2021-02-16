# CodeName

## Development
To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.


## Production

The app is deployed thanks to gigalixir at the following address: [https://code-name-duo.gigalixirapp.com/](https://code-name-duo.gigalixirapp.com/).


Console to monitor the app: [https://console.gigalixir.com/#/apps/code-name-duo](https://console.gigalixir.com/#/apps/code-name-duo)

Useful commands:

- Push to production: `git push gigalixir`
- Run migrations: `gigalixir run mix ecto.migrate`
- Run seeds: `gigalixir run -- mix run priv/repo/seeds.exs`
- See logs: `gigalixir logs`
- Open app: `gigalixir open`

Docs used to deploy:
- [Gigalixir docs](https://gigalixir.readthedocs.io/en/latest/getting-started-guide.html)
- [Gigalixir tutorial](https://www.mitchellhanberg.com/how-to-deploy-a-phoenix-app-to-gigalixir-in-20-minutes/)
- [Phoenix deployment guide](https://hexdocs.pm/phoenix/deployment.html).

TODO: change server to europe central

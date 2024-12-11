# CodeName

## Description

This is a [code name duo](https://www.amazon.fr/iello-Codenames-Duo-dambiance-51472/dp/B076X5VSYM/ref=sr_1_2?adgrpid=58959740871&dib=eyJ2IjoiMSJ9._XnNYphYt_BKherWF2Y4Zd6vlyXRtezvMsnQ5DQWKmKdxu1tIEAy3SOLxMqnnc3aZnhDG8RuF4qEqBIQWQEaKPhOCPEqOZdzb1B1_XlSiQsX757J2HRPHKjfwS7fOD500u-C_h87ANDRI_juoBFcL2wlhRl4pEO9Vn8JakTjHzK4Gs8s1NBEtTrwQTtIO22iIlJDsg9-Pf6LaRQfQlvgm6-NIuGTjvbFPKFETnJ_IAZtX84Z-tfoqGXhp4pnXVIGwIbN8MpaCr3dLW2pJ48i3BiRS7ju5b1HJxdUNikRdNM.PmeyNvYXXHHlNFn8V9u7vCfmpwKh45Sb-ajg-z4mVZQ&dib_tag=se&hvadid=601278808023&hvdev=c&hvlocphy=9111032&hvnetw=g&hvqmt=e&hvrand=5109963394490193346&hvtargid=kwd-399128526398&hydadcr=7712_2269579&keywords=code+name+duo&nsdOptOutParam=true&qid=1733899621&sr=8-2) app I built to try out Elixir and the phoenix framework. It is not live anymore.

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

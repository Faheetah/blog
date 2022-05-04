# Blog

A generic blog written in Elixir

## Deploying

Create a systemd file with the following information:

```
WorkingDirectory=/path/to/application
ExecStartPre=/path/to/application/bin/blog eval 'Blog.Release.migrate'
ExecStart=/path/to/application/bin/blog start
ExecStop=/path/to/application/bin/blog stop
EnvironmentFile=/path/to/secrets
Environment=LANG=en_US.utf8
Environment=MIX_ENV=prod
Environment=PHX_SERVER=true
Environment=RELEASE_NAME=blog
```

The `secrets` file should look similar to

```
DATABASE_URL='ecto://username:password@localhost:5432/blog'
SECRET_KEY_BASE='value created with mix phx.gen.secret'
```

For releases, run the following

```
MIX_ENV=prod mix phx.digest.clean --all
MIX_ENV=prod mix assets.deploy
MIX_ENV=prod mix release --overwrite
rsync -av _build/prod/rel/blog/ SERVER:PATH
ssh SERVER 'sudo systemctl restart blog' # or whatever matching service is
```

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
```

The `secrets` file should look similar to

```
DATABASE_URL='ecto://username:password@localhost:5432/blog'
SECRET_KEY_BASE='value created with mix phx.gen.secret'
```

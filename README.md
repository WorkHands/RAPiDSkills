# RAPiDSkills

The RAPiDSkills API is a Ruby on Rails application hosted on Heroku.  It is
written using Ruby 2.6.5 and Rails 6.0.1. It uses Postgres 11.5, Redis 5.0, and
Elasticsearch 7.2.0.

## Development setup
The following commands should just be run for the initial setup only. Rebuilding the docker images is only necessary when upgrading, if there are changes to the Dockerfile, or if new gems have been added.
1. Install [Docker Community Edition](https://docs.docker.com/install/) if it
   is not already installed.
1. Clone the repository: `git clone --recurse-submodules git@github.com:WorkHands/RAPiDSkills.git`
3. Run `docker-compose build` to build images for all services.
4. Run `docker-compose up -d database` to start the database service.
4. Run `docker-compose run --rm web rails db:reset` to create the dev and test databases, load the schema, and run the seeds file.
4. Run `docker-compose up -d` to start all the remaining services.
5. The client application will be available at http://localhost:8080.
5. The server application will be available at http://localhost:3000. To access the admin dashboard, visit http://localhost:3000/admin/login.
5. If you have Heroku access to the production application, you can import a copy of the production database into your local database by running: `bin/database_import.sh`. Note that this will completely replace your local database.

If you cloned the directory without the documentation submodule, you must initialize and update the submodule in order to have the `middleman` service start correctly:
1. Change into the documentation directory: `cd documentation`
2. Pull in the submodule: `git submodule update --init`

For ongoing development:
1. Run `docker-compose up -d` to start all services.
1. Run `docker-compose stop` to stop all services.
1. Run `docker-compose restart web` to restart the web server.
4. Run `docker-compose down -v` to stop and remove all containers, as well as volumes and networks. This command is helpful if you want to start with a clean slate.  However, you will need to go through the database setup steps again above.

### Running commands
In order to run rake tasks, rails generators, bundle commands, etc., they need to be run inside the container:
```
docker-compose exec web rails db:migrate
```

If you do not have the web container running, you can run a command in a one-off container:

```
docker-compose run --rm web bundle install
```

However, when using a one-off container, make sure the image is up-to-date by
running `docker-compose build web` first.  If you have been making gem updates
to your container without rebuilding the image, for example, then the one-off
container will be out of date.

### Viewing logs
To view the logs, run:
```
docker-compose logs -f <service>
```

For example:
```
docker-compose logs -f web
```

### Accessing services
#### Postgres database
```
$ docker-compose exec database psql -h database -Upostgres rapidskills_development
```
Enter password when prompted (use `POSTGRES_PASSWORD` environment variable in `config/docker.env`).

#### Rails console
```
$ docker-compose exec web rails c
```

#### Redis CLI
```
$ docker-compose exec redis redis-cli -h redis
```

### Troubleshooting
* If you receive an error that the web service cannot access Elasticsearch, then stop the web service and restart only after confirming through the logs that the elasticsearch service has fully loaded.
    ```
    $ docker-compose stop web
    $ docker-compose logs -f elasticsearch
    $ docker-compose up -d web
    ```

* If you receive an error when running the specs that includes `FORBIDDEN/12/index read-only` in relation to Elasticsearch, then the elasticsearch container has less than 5% of free disk space and has switched to read-only mode. In this case, stop and remove the container, and then restart the elasticsearch service.
    ```
    $ docker-compose stop elasticsearch
    $ docker-compose rm -f elasticsearch
    $ docker-compose up -d elasticsearch
    ```

## Mailcatcher
We use [Mailcatcher](https://mailcatcher.me/) to receive mail in development.
All mail sent in the development environment can be viewed at http://localhost:1080.

## Documentation editing
The API Documentation is generated from [Slate](https://github.com/slatedocs/slate).
1. Start the middleman service if it is not already running: `docker-compose up -d middleman`
2. Change into the documentation directory: `cd documentation`. You will now be working in a git submodule, which has its own separate git repository.
3. Edit files in the `/source` directory. The changes can be viewed at http://localhost:4567.
4. Commit files, merge to master, and push to Github.
5. Return to main app repository: `cd ..`
6. Run `docker-compose run --rm middleman bin/generate_static_pages.rb` to generate the static html pages that will get saved in the main repo.
6. Run `git status`. You will see that the `documentation` directory has modifications, as well as updates to the `app/lib/docs` files.
7. Commit both the `documentation` changes and the changes to the `docs` directory into the main repository.

## Secret keys
To edit the encrypted credentials for staging and production, you must have the
master key files stored in `config/credentials/staging.key` and
`config/credentials/production.key`.

To edit:

```
$ docker-compose run --rm -e EDITOR=vim web rails credentials:edit --environment <environment>
```

For example:

```
$ docker-compose run --rm -e EDITOR=vim web rails credentials:edit --environment staging
```

## Testing Suite

We are using [RSpec](http://rspec.info/) for tests.  Before beginning a new
feature, please run the specs and make sure the entire test suite is passing.
All tests should be passing when submitting a PR.  Please write specs as
appropriate.

To run all specs:

```
$ docker-compose exec web rspec spec -fd
```

To run an individual file:

```
$ docker-compose exec web rspec spec/models/user_spec.rb -fd
```

To run an individual spec, pass the spec name or partial match:
```
$ docker-compose exec web rspec spec/models/user_spec.rb -fd -e "valid factory"
```

Individual specs can also be run by specifying the line number:

```
$ docker-compose exec web rspec spec/models/user_spec.rb:4 -fd
```

## Certificate Management

These should be managed automatically by Heroku: https://devcenter.heroku.com/articles/automated-certificate-management. However, if they expire, you can run the following:

```
$ heroku certs:auto:enable
```

To see the current status of certs, run:

```
$ heroku certs

patricks-mbp:RAPiDSkills patrickcushing$ heroku certs
Name                Common Name(s)                Expires               Trusted  Type
──────────────────  ────────────────────────────  ────────────────────  ───────  ────
triceratops-36981   rapidskillsgenerator.org      2021-02-18 01:37 UTC  True     ACM
tyrannosaurs-86057  www.rapidskillsgenerator.org  2021-03-10 16:05 UTC  True     ACM
```

It's probably a good idea to check that these renew automatically on the next renewal date in February.
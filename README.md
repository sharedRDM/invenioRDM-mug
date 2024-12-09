# invenioRDM-mug

invenioRDM deployment example for MUG

## Nginx

Nginx example configuration can be found under [nginx](nginx).

## Demo

**update the environment variables.** [.env.temp](.env.temp)

```bash
docker compose -f demo-compose.yml up -d
```

Once running, visit https://127.0.0.1 in your browser.

**Note**: The server is using a self-signed SSL certificate, so your browser
will issue a warning that you will have to by-pass.

## Initialization

To set up your database, indexes, and related components, follow these steps.  
**Note:** These commands should only be run during the initial setup. Running them multiple times may result in data loss.

1. Access the container's shell:
   ```bash
   docker exec -it UI-CONTAINER bash
   ```
2. Run the following commands one by one:

    ```bash
    # Clear the cache
    invenio shell --no-term-title -c "import redis; redis.StrictRedis.from_url(app.config['CACHE_REDIS_URL']).flushall(); print('Cache cleared')"

    # Drop existing database (if any)
    invenio db drop --yes-i-know

    # Destroy existing indexes
    invenio index destroy --force --yes-i-know

    # Purge the indexing queue
    invenio index queue init purge

    # Create a fresh database
    invenio db create

    # Set up the default file storage location
    invenio files location create --default 'default-location' /opt/invenio/var/instance/data

    # Create an admin role
    invenio roles create admin

    # Grant superuser access to the admin role
    invenio access allow superuser-access role admin

    # Initialize indexes
    invenio index init --force
    ```

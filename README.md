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
   
    # fixtures data
    invenio rdm-records fixtures
    ```

3. (Optional) add demo data:

    ```bash
    # demo data
    invenio rdm-records demo
    ```
4. (Optional) create users:

    ```bash
    # create a users with cli
    invenio users create user01@inveniordm.example.com --password <YOURPASSWORD> --active --confirm
    
    invenio users create admin@inveniordm.example.com --password <YOURPASSWORD> --active --confirm

    # give a user admin role
    invenio roles add admin@inveniordm.example.com admin
    ```
5. (Optional) rebuild indexes for rdm (reserach results)
   ```bash
   invenio rdm rebuild-all-indices
   ```

## MUG

For this deployment, we have set up a new NGINX container without SSL enabled, which acts as a reverse proxy for both the UI and API containers. **MUG** should use port `8000` of this container to route requests through its own proxy server.

**update the environment variables.** [.env.temp](.env.temp)

```bash
docker compose -f mug-compose.yml up -d
```


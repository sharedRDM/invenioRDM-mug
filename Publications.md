
### Publications

To have publications available, there is a need to have a few more things configured.

1. Make sure to have the correct invenio.cfg for Publications:

    ```python
    OVERRIDE_SHOW_PUBLICATIONS_SEARCH = True
    GLOBAL_SEARCH_SCHEMAS = {
        "rdm": {
            "schema": "rdm",
            "name_l10n": "Research Result",
        },
        "marc21": {
            "schema": "marc21",
            "name_l10n": "Publication",
        },
    }
    ```

**The following set of commands to initialize publications can be run directly with:**
```bash
docker cp ./setup_publications.sh <UI-CONTAINER>:/setup_publications.sh
docker exec <UI-CONTAINER> /setup_publications.sh
```

2. Add Publication (marc21) roles.

    ```bash
    invenio roles create Marc21Curator
    invenio roles create Marc21Manager
    invenio roles create Marc21Creator
    ```
3. Handle Database Migrations

    Publications contain database schema changes, so run the migration using:

    ```bash
    invenio alembic upgrade 
    ```

4. Create Global-Search Tables  

    Before initializing indices, ensure the database has the required tables for global search:

    ```bash
    invenio db create
    ```

5. Rebuild Indices for Newly Installed Packages

    After adding **marc**, rebuild its indices:

    ```bash
    invenio marc21 rebuild-index
    invenio global-search rebuild-database
    ```

6. (Optional) Load Demo Records for Publications

    If you want to try the demo records for publications, run:  
    ```bash
    invenio marc21 demo -b -m -n 10
    ```

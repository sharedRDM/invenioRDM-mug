# 🌍 Global Search

Initial steps to integrate **Global Search** into your project.

---

## 🚀 Setup Instructions

Run the following commands in your terminal:

```bash
invenio alembic upgrade
invenio db create
invenio global-search rebuild-database
```

**Debugging**

If you want to make sure global-search is setup correctly, you should connect to the database and check for `global_search_metadata` table.

If you encounter problems with `alembic upgrade` command, try:

```sql
delete from alembic_version where version_num=<problematic_version>;
```

then run again `invenio alembic upgrade`. If you remove packages that ran alembic scripts in the past and don't cleanup this table, this can lead to errors.

If you detect problems with the gs-index, try running:

`invenio global-search rebuild-database` 


## 📚 Documentation

Full documentation and configuration details:

[https://tu-graz-library.github.io/docs-repository/features/gs/](https://tu-graz-library.github.io/docs-repository/features/gs/)
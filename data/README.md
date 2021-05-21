This folder is used for storing user-specific data files that you may want to copy in to a Docker container. These are included in a container instance with the following commands in the `Dockerfile`:

```
COPY data/store.sqlite3 /usr/local/pelias/placeholder/data/
```

Importantly any files included in this folder ending `.db`, `.sqlite` or `.sqlite3` are explicitly _excluded_ from being included in any Git commits.
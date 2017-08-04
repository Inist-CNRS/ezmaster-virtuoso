# ezmaster-virtuoso

ezmasterized virtuoso (Triple store)

Make an [ezMaster](https://github.com/Inist-CNRS/ezmaster) version of [OpenLink Virtuoso](https://github.com/openlink/virtuoso-opensource) (inspired from
[tenforce's version](https://github.com/tenforce/docker-virtuoso)).

See [ezmaster-hexo](https://github.com/Inist-CNRS/ezmaster-hexo)'s code.

## Build

    docker build --tag ezmaster-virtuoso:2.0.0 .

## Versioning

Use semver, but don't prefix version tag with `v`.

## Load data

To load triples files (N-Triples, `.nt`), use the
[conductor interface](http://docs.openlinksw.com/virtuoso/htmlconductorbar/#rdfadm).

Don't forget to create graph explicitly.

> **Warning**: don't use the previous loading method, using ezmaster's WebDAV:
> the location of the files to load would be different, and, at the moment, this
> method does not work any more.

### Named graphs

To get the named graph into which you want to upload the data, use the naming
convention: all pointed parts `.` (except extension) will be taken as the _domain_,
and underline character(s) `_` will be converted into slash characters `/`.

Example:

`ns.nature.com_graphs_articles.nq` will be `http://ns.nature.com/graphs/articles`

## Configuration

If you want to change an environment variable within the container, add (or
modify) a `env` section within the ezMaster instance's configuration, and a key value pair.

Ex:

```json
{
  "env": {
    "DBA_PASSWORD": "secret"
  }
}
```

That will add the `DBA_PASSWORD` environment variable in virtuoso environment
before running it.

### Available variables

- `DBA_PASSWORD`:  the password for the administrator
- `SPARQL_UPDATE`: `true` if you want to update the data via SPARQL

### .ini configuration

All properties defined in [`virtuoso.ini`](https://github.com/tenforce/docker-virtuoso/blob/8ea659bde39644b56a9934776858ede28eee06f0/virtuoso.ini) can be configured via the JSON configuration variables. They must follow the section / key / value structure, and are case sensitivE. They
should be CamelCased as in `virtuoso.ini`.

E.g. property `ErrorLogFile` in the `Database` section should be configured as following:

```json
{
  "Database": {
    "ErrorLogFile": "error.log"
  }
}
```

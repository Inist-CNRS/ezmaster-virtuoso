# ezmaster-virtuoso
ezmasterized virtuoso (Triple store)

Make an [ezMaster](https://github.com/Inist-CNRS/ezmaster) version of [OpenLink Virtuoso](https://github.com/openlink/virtuoso-opensource) (inspired from
[tenforce's version](https://github.com/tenforce/docker-virtuoso)).

See https://github.com/Inist-CNRS/ezmaster-hexo

## Build

    docker build --tag ezmaster-virtuoso:1.0.0 .

## Versioning

Use semver, but don't prefix version tag with `v`.

## Load data

To load a NQuads file (`.nq`), you need an instance of `ezmaster-virtuoso`
running in ezMaster.

You can then upload the `.nq` file(s).

To initiate the load process, you have to stop the instance, and start it again.

The instance will load all recent files (that is to say, all the files more
recent than the last start).

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

All properties defined in [`virtuoso.ini`](https://github.com/tenforce/docker-virtuoso/blob/8ea659bde39644b56a9934776858ede28eee06f0/virtuoso.ini) can be configured via the environment
variables. The environment variable should be prefixed with `VIRT_` and have a
format like `VIRT_$SECTION_$KEY`. `$SECTION` and `$KEY` are case sensitive. They
should be CamelCased as in `virtuoso.ini`.

E.g. property `ErrorLogFile` in the `Database` section should be configured as `VIRT_Database_ErrorLogFile=error.log`.

```json
{
  "env": {
    "VIRT_Database_ErrorLogFile": "error.log"
  }
}
```
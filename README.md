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

## Configuration

If you ant to change an environment variable within the container, add (or
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

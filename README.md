# MTAR Loader

Provides a simple read-only environment for OpenComputers programs, packed in one file - a [MTAR v1](https://git.shadowkat.net/izaya/OC-misc/src/branch/master/mtar) archive.

`mtarldr` provides a faux `filesystem` component object at `_G.mtarfs`.  This may be treated like a read-only `filesystem` component.

# Configuration Options

In the config file:

```
PLATFORM managed                the platform to run on, managed for now
BOOT_FILE boot/example.lua      the file to execute from the mtar
BOOT_ARGS a, b, c, ...          boot arguments to pass to BOOT_FILE
CHUNKS 2048                     chunk size while finding data
CHUNKS_HEADER 512               chunk size while reading file headers
SPINTERVAL 0.1                  interval between spinner frames
```

Environment variables given to `scripts/build`:

```bash
PROGNAME=example    # output file name sans .lua extension
DIR=build           # the directory to archive
CONFIG=./config     # path to a file with pairs like above
OUT=.               # where to place the output file
```

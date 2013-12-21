mdb\_to\_sqlite
=============

This is a script to convert a Microsoft Access MDB database to an
SQLite database.

Usage
-----

Invoke the script with `perl mdb_to_sqlite.pl MDB_FILE OUT_FILE` to export
`MDB_FILE` to `OUT_FILE`.

If `OUT_FILE` exists, you will be prompted for whether or not you want to
overwrite it: if you will be running the script automatically and don't
care about overwrites, add the `--auto-overwrite` option when you run the script.

Requirements
------------

The only requirement for this script is the [mdb-tools](http://mdbtools.sourceforge.net)
suite of programs. The only binaries available seem to be for Linux, so that might
mean that this script is Linux-only as well. However, the source is available,
so you may be able to compile it yourself for whatever OS you use.

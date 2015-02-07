## Encina's display development

Use the Gruntfile.coffee of the project's root directory by running `make grunt` there. At the same time, use a static server like `http-server` at the `devel` directory or just run `make server` at the project's root directory.

In order to work, you need to use data. Generate a `encina-reports` and copy the `data.json` file in the devel directory. You can simply run `make generate-devel-data` (remember make's autocompletion features).
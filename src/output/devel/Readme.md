## Encina's output development

Use the Gruntfile.coffee of the root directory by running `grunt` there. At the same time, use a static server like `http-server` at the `devel` directory.

To work with fake data, copy the content of one of the files and put it in `data.json`. When commiting, be sure to leave the data.json with the `before-commit.json` data (or just better just `make before-commit`).
## Testing Encina

There are several handy ways of running the test. The first is with the `make` commands, like `make tests-e2e-frontend-headless`, in case you want to run all the tests. If you want to be more specific and be able to pass arguments to select just some tests, you can use the bin files of this directory, e.g. from the Encina's root directory: `./test/bin/SCRIPT ARGUMENTS`.

Each script is explained in the following lines. To do this, you need to set those bin files as executables, for example with `make set-test-bin-executable`.

### e2e-frontend

Run this script to select a specific directory or test. As each file requires to create the report + setup the server, running just one test file will be dramatically faster than running all. Give as the first argument the display mode (`visual` or `headless`), and as the second, the path to look from the `test/2e2/frontend/` point. For example:

`./test/bin/e2e-frontend headless home`

This would run just the tests in that directory. You can also specify a file. There are also the `e2e-frontend-visual` and `e2e-frontend-headless` helpers that automatically set the display mode so you can put one or zero arguments.

### unit-backend

The same as before, you can select a specific test with this command.

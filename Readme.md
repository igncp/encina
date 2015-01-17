# [Encina](http://igncp.github.io/encina/)

[![npm version](https://badge.fury.io/js/encina.svg)](http://badge.fury.io/js/encina)

A command line tool for analyzing projects and retrieving statistics. Once completed, you can inspect the result using an interactive interface, with charts (D3) and formatted data. Encina stands for ***holm oak*** in Spanish.

[![Encina Logo](/misc/encina.jpg)](https://github.com/igncp/encina)

"¿Qué tienes tú, negra encina campesina con tus ramas sin color en el campo sin verdor; con tu tronco ceniciento sin esbeltez ni altiveza, con tu vigor sin tormento, y tu humildad que es firmeza?"

-- <cite>Antonio Machado</cite>

## Requirements

- Debian environment
- Node.js
- Python (with NumPy and Pandas libraries)

## Usage

You can use `encina` from the command line once the module is installed. If you want to use it anywhere, install it as a global module `npm install -g encina`.

- To retrieve data from a project: `encina examine PATH/TO/PROJECT` 
- To display the result: `encina server` in the directory that contains the `encina-report` result. In a browser, go to: `http://localhost:9993` or add the `-b` flag to the command.

Please go to the [homesite](http://igncp.github.io/encina/) for further information.

## Examples

The `examine` command is relatively fast, for example with the entire Rails project:

![encina examine](/misc/examine.gif)

A demo of a report of the last published version can be found [here](http://encina-report.herokuapp.com/) (You may have to wait ~10 seconds till the heroku server is woken up).


## Technologies covered

- Backend: Python for the data analysis, Node.js, CoffeeScript, Stylus (nib), Grunt, Express
- Frontend: Angular.js, Angular UI Router, D3.js, Bootstrap, Require.js, Lodash.js, jQuery (UI), Moment.js

## Development

Download the repository and use the Makefile. For example, `make server` and `make grunt` for the output development.

## Author and License

Ignacio Carbajo · 2014 - 2015

MIT

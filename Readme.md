# Encina

[![npm version](https://badge.fury.io/js/encina.svg)](http://badge.fury.io/js/encina)

A command line tool for analyzing projects and retrieving statistics. Once completed, you can inspect the result using an interactive interface, with charts (D3) and formatted data.

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

## Technologies covered

- Backend: Python for the data analysis, Node.js, CoffeeScript, Stylus (nib)
- Frontend: Angular.js, D3.js, Bootstrap, Require.js, Lodash.js, jQuery (UI)

## Development

Download the repository and run the Makefile using `make`.

## Author and License

Ignacio Carbajo · 2014 - 2015

MIT

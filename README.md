# Project: Command Line Interface Bowler

## Motivation

I have always wanted to create a program to keep stats on my bowling
progress.  Some time ago, I was the president of a league.  During this time
I was able to use software to keep track of the leagues information.  This
software was purchased.  I was fine with that but not fine with the licence.
The licence was only allowed to be used for one league.  I want to give
options to users.

## Requirements

* Bash (4.3.48)
* Sqlite3 (3.11.0)

These are the programs I am using to make this.  I would like input if this
works on different versions of software.

## Installation

### Git Method

> git clone git@github.com:linux478/cli-bowler.git
> cd cli-bowler.git
> chmod 755 cli-bowler.sh

### Download

    wget https://github.com/linux478/cli-bowler/archive/master.zip
    unzip master.zip
    cd cli-bowler-master
    chmod 755 cli-bowler.sh

## Run Program

./cli-bowler.sh

More examples in the doc/user.md

## Files

    ./
    |-- LICENSE                -- license agreement
    |-- cli-bowler.db          -- default location for your information
    |-- cli-bowler.sh          -- the program (should be executable)
    |-- cli-bowlerrc           -- program configuration file
    `-- doc
        |-- programmer.md      -- documentation for the programmer
        `-- user.md            -- documentation for the user
    |-- README.md              -- this file

**NOTE:** cli-bowler.db is not part of the distribution 
## MIT License

Copyright (c) [2018] [Michael Phillips]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to
deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
sell copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
IN THE SOFTWARE.

things-rb
=========

things-rb is a Ruby library and a command line tool for accessing the backend of the GTD app [Things.app](http://culturedcode.com/things/)

## Why?
There are many reasons why you would use a command line version of Things, including: 

![GeekTools](http://img.skitch.com/20090323-xacfsghrsi7p6yjt1x2fnse8ek.jpg)

- Keep a list of your ToDos on the desktop using an app like [GeekTool](http://projects.tynsoe.org/en/geektool/)
- Access your ToDos remotely by SSH:ing into your machine (even from a Windows or Linux box)
- You don't need to have Things.app running all the time
- You like the Terminal and command line

## Install

    gem install haraldmartin-things-rb --source http://gems.github.com


## Usage

things-rb can be used either as a Ruby library or with the included command line tool. 

### Ruby Library

Example usage:

    things = Things.new # will use Things' default database location. 
    # things = Things.new(:database => '/path/to/Database.xml')
    
    tasks = things.today.map do |task|
      tags    = "(#{task.tags.join(' ')})" if task.tags?
      project = "[#{task.parent}]" if task.parent?
      bullet  = task.completed? ? "✓" : task.canceled? ? "×" : "-"
      [bullet, task.title, tags, project].compact.join(" ")
    end
    
    puts tasks.compact.sort.join("\n")
    
### Command Line Use

    $ things
    $ things --help
    
Shows all the options available. 

The most common use I assume would be:
    
    $ things today
  
which lists all tasks in "Today" which are not already completed.
    
If you like to show completed and canceled tasks, just pass the `--all` option
        
    $ things --all today

Be default, things-rb will use the default location of the Things' database but if you keep it somewhere else you can
set a custom path using the `-d` or `--database` switch

    $ things --database /path/to/Database.xml

Replace `today` with other focus to list the task

    $ things --all next
    $ things logbook


## Testing

To view test document (`test/fixtures/Database.xml`) in Things, just launch Things.app with ⌥ (option/alt) down and click "Choose Library" and point it to `things-rb/test/fixtures`. 
Be sure to disable automatic logging of completed tasks in the Things.app preferences so they won't be moved around in the document.


## TODO
- Write support (add tasks via the library)
- Support "Projects" focus
- Support due dates, notes etc
- Optimize test and XML queries
- Add tag support to binary
- Organize the clases, make internal methods private


## Credits and license

By [Martin Ström](http://my-domain.se) under the MIT license:

>  Copyright (c) 2008 Martin Ström
>
>  Permission is hereby granted, free of charge, to any person obtaining a copy
>  of this software and associated documentation files (the "Software"), to deal
>  in the Software without restriction, including without limitation the rights
>  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
>  copies of the Software, and to permit persons to whom the Software is
>  furnished to do so, subject to the following conditions:
>
>  The above copyright notice and this permission notice shall be included in
>  all copies or substantial portions of the Software.
>
>  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
>  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
>  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
>  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
>  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
>  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
>  THE SOFTWARE.
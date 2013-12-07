Copying
=======

Copyright 2013 Matthew Harvey

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

Overview
========

``vat`` stands for "Vim Awk Todo". It is a very simple todo list manager,
inspired by t_.  It is designed to be used from the command line in conjunction
with Vim_.

I wrote ``vat`` because I loved the simplicity of ``t``, but, for my own
requirements at least, felt it lacked a couple of useful features. Also I didn't
feel the need for certain other features, such the hash-based task identifiers
provided by ``t``, or the ability to retain tasks on file after they're
completed. (In ``vat``, the only official way to mark a task as completed
is simply to delete it. Though, of course, you could always put your
todo file into version control...)

``vat`` is a small but significant step up from "just storing your todos in
a text file". With ``vat``, you can do the following from the command line:

- See a list of one-line task summaries from sorted by due date.
- Ask to see the full detail for a particular task.
- Open your todo file directly at particular task for rapid editing in Vim.

If you like the command line and Vim, then these few features should save you
a lot of time and hastle, relative to the "mere text file" approach.

``vat`` is a minuscule ``awk`` script; you can easily hack it to
suit your own requirements.

Dependencies
============

``vat`` should work on any Unix-like system on which ``awk``, ``sort`` and
``vim`` are available.

To get the most out of ``vat``, it's best if you're familiar with Vim_.

Installation
============

- ``chmod +x vat.awk``
- Copy ``vat.awk`` into a directory of your choosing.
- Create a text file somewhere to record your tasks.
- Add something like the following line to your ``.bashrc`` (or ``.zshrc`` or
  etc.)::

    alias vat='/path/to/vat.awk /path/to/text/file/containing/tasks'

Usage
=====

Task file format
----------------

``vat`` processes the contents of the tasks file at the filepath recorded in
``.bashrc`` as described above. The tasks file is a plain text file in which
tasks are recorded in a certain simple format.

Here is an example of that format:

::

    2013-03-09
    The first line can be thought of as a summary of the task.
    The rest is the body of the task. The task needn't have a body.
    Tasks are separated by blank lines.

    2013-11-28
    A date in this ISO format represents the date the task is due.
    Put the date at the start of the first line.

    This task doesn't have a due date.
    That's OK. Also note the tasks can be in any order in the file.

    2013-09-09
    A task doesn't need to have a body.

    This task has no due date and no body and that's fine.

    Buy milk.

    Do stuff.


Command line usage
------------------

The following usage instructions assume you have aliased ``vat`` in your
``.bashrc`` as described under Installation_.

To display all task summaries ordered by due date::
    
    vat

This will output the due date, ID and summary of each task. Tasks that
don't have a date will be listed first (these in no particular order), and
will have a ``0`` in the date column. Tasks with due dates will then be
listed, in ascending order of date.

Here is some sample output::

    DUE         ID  SUMMARY
    0            3  This task doesn't have a due date.
    0            5  This task has no due date and no body and that's fine.
    0            6  Buy milk.
    0            7  Do stuff.
    2013-03-09   1  The first line can be thought of as a summary of the task. 
    2013-09-09   4  A task doesn't need to have a body. 
    2013-11-28   2  A date in this ISO format represents the date the task is due. 

This output can of course be piped to ``grep`` and other tools as you see fit.

Note the task ID is ephemeral in the sense that if the task file is edited, the
ID of any task is liable to change, including tasks that were not
themselves edited.

To display the date, summary *and detail* of a particular task::

    vat [ID]

For example, entering ``vat 2`` will produce the following::

    2013-11-28
    A date in this ISO format represents the date the task is due.
    Put the date at the start of the first line.

To add a new task::

    vat e

This will open the task file in Vim_, at the first line. You can then hit
"CTRL-O" and start writing a new task at the top of the file. Be sure to leave
a blank line between it and the next task. Note you can add a new task anywhere
in the file - order isn't relevant - as long as it's separated from adjacent
tasks by a blank line. Exit Vim as usual with ``x`` or ``wq`` to save the new
task.

To edit or delete a task::

    vat e[ID]

This will open the task file in Vim_ at the task identified by ``[ID]``. E.g.
entering ``vat e6`` will open the task file with the cursor
positioned on the task with an ID of ``6``. You then edit the text
of the task directly in Vim_, or, if desired, delete it entirely. Exit Vim_
as usual with ``x`` or ``wq``, and you're done.

For the sake of convention, the options detailed above also work with ``-``
prefixed before the option. I.e. ``-e``, ``-e90`` and ``90`` are all valid.
But the hyphen is entirely unnecessary. Note, however, that ``e 90`` and
``-e 90`` are not valid: the number must not be separated from the ``e``.

Contact
=======

vat@matthewharvey.net

.. References
.. _Vim: http://www.vim.org
.. _t: http://stevelosh.com/projects/t/


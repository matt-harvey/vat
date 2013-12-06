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

``tm`` is a simple command-line task management program, inspired by t_.
It is designed to be used from the command line in conjunction with Vim_.

Similarities with t_:

- Minimalist.
- Convenient to use from the command line.

Differences with t_:

- Explicitly supports the concept of an (optional) due date for each task;
  tasks summaries are output in order of due date.
- Task descriptions can span multiple lines, commencing with an optional due
  date, then a line representing the "summary", then optional additional lines
  representing the "detail".
- Tasks are identified by an ephemeral, ad hoc ID number, based on their order
  in the file at a given point in time, rather by a hash.
- Tasks aren't edited directly from the command line; rather,
  you tell ``tm`` to open Vim_ at a particular task, and then edit it using
  Vim.
- There is no support for marking a task as completed. When it's done,
  you delete it.
- It's implemented in about 30 lines of Awk :-)

Requirements
============

``tm`` should work on any Unix-like system on which ``awk``, ``sort`` and Vim
are available.

To get the most out of ``tm``, it's best if you're familiar with Vim_.

Installation
============

- ``chmod +x tm.awk``
- Copy ``tm.awk`` into a directory of your choosing.
- Create a file somewhere where you want to record your tasks.
- Add something like the following line to your ``.bashrc`` (or ``.zshrc`` or
  etc.)::

    alias tm='/path/to/tm.awk /path/to/file/containing/tasks'

Usage
=====

Task file format
----------------

``tm`` processes the contents of the tasks file at the filepath recorded in
``.bashrc`` as described above. The tasks file is a plain text file in which
tasks are recorded in a certain simple format.

Here is an example of that format:

::

    2013-11-2
    A date in this ISO format represents the date the task is due.

    2013-03-09
    The first non-date line can be thought of as a summary of the task.
    The remaining is the "detail" of the task.
    Tasks are separated by blank lines.

    This task doesn't have a due date. This is still its summary line.
    And this line is still in its detail section,
    as is this. Also note the tasks can be in any order in the file.

    2013-09-09
    A task doesn't need to have a detail section.

    This task has no due date and no body and that's fine.

    Buy milk.

    Do stuff.

Command line usage
------------------

To display all task summaries ordered by due date::
    
    tm

This will output the due date, ID and summary of each task. Tasks that
don't have a date will be listed first (these in no particular order), and
will have a ``0`` in the date column. Tasks with due dates will then be
listed, in ascending order of date.

Here is some example output::

    0            3  This task doesn't have a due date.
    0            5  This task has no due date and no body and that's fine.
    0            6  Buy milk.
    0            7  Do stuff.
    2013-03-09   1  The first line can be thought of as a summary of the task. 
    2013-09-09   4  A task doesn't need to have a body. 
    2013-11-28   2  A date in this ISO format represents the date the task is due. 

Note the task ID is ephemeral in the sense that if the task file is edited, the
ID of any task is liable to change, including tasks that were not
themselves edited.

To display the date, summary *and detail* of a particular task::

    tm [ID]

To add a new task::

    tm e

This will open the task file in Vim_, at the first line. You can then hit
"CTRL-O" and start writing a new task at the top of the file. Be sure to leave
a blank line between it and the next task. Note you can add a new task anywhere
in the file - order isn't relevant - as long as it's separated from adjacent
tasks by a blank line. Exit Vim as usual with ``x`` or ``wq`` to save the new
task.

To edit or delete a task::

    tm e[ID]

This will open the task file in Vim_ at the task identified by ``[ID]``. E.g.
entering ``tm e19`` will open the task file with the cursor
positioned on the task with an ID of ``19``. You then edit the text
of the task directly in Vim_, or, if desired, delete it entirely. Exit Vim_
as usual with ``x`` or ``wq``, and you're done.

.. References
.. _Vim: http://www.vim.org
.. _t: http://stevelosh.com/projects/t/

Contact
=======

tm@matthewharvey.net

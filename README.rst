Overview
========

``vat`` stands for "Vim Awk Todo". It is a very simple todo list manager,
inspired by t_.  It is designed to be used from the command line in conjunction
with Vim_.

``vat`` is a small but significant step up from "just storing your todos in
a text file". With ``vat``, you can do the following from the command line:

- See a list of one-line task summaries sorted by due date.
- Open your todo file directly at a specified task for rapid editing in Vim.
- Output the full text of a specified task to the console.

If you like the command line and Vim, then these few features should save you
a lot of time and hastle, relative to the "mere text file" approach.

``vat`` is a very small ``awk`` script; you can easily hack it to
suit your own requirements.

Dependencies
============

``vat`` should work on any Unix-like system on which ``awk``, ``sort`` and ``cat``
are available.

As far as specific implementations of ``awk`` are concerned, ``vat`` is known to
work with GNU Awk 4.0.2 and ``nawk`` version 20121220; but it should work with
any other non-ancient implementation.

To get the most out of ``vat``, it's best if you're familiar with Vim_.

Installation
============

- Copy ``vat.awk`` into a directory of your choosing.
- Create a blank text file somewhere to record your tasks (``touch /path/to/file``).
- Add something like the following line to your ``.bashrc`` (or ``.zshrc`` or
  etc.)::

    alias vat='awk -f /path/to/vat.awk /path/to/text/file/containing/tasks'

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
    The first line that isn't a date serves as a summary of the task.
    The rest is the body of the task. The task needn't have a body.
    Tasks are separated by blank lines.

    2013-11-28
    A date in this ISO format represents the date the task is due.
    Put the date at the start of the first line.

    This task doesn't have a due date.
    That's OK.

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
don't have a date will be listed first, in the same order in which
they appear in the tasks file. Tasks with due dates will then be
listed, in ascending order of date. Tasks sharing the same date appear
in the same relative order as in the tasks file.

Here is some sample output::

    DUE         ID  SUMMARY
                 3  This task doesn't have a due date.
                 5  This task has no due date and no body and that's fine.
                 6  Buy milk.
                 7  Do stuff.
    2013-03-09   1  The first line that isn't a date serves as a summary of the task. 
    2013-09-09   4  A task doesn't need to have a body. 
    2013-11-28   2  A date in this ISO format represents the date the task is due. 

This output can of course be piped to ``grep`` and other tools as you see fit.
For example, if you put a project-specific string at the start of each summary
line, you can use ``grep`` to filter the output of ``vat`` to see the tasks for
a given project.

Note the task ID is ephemeral in the sense that if the task file is edited, the
ID of any task is liable to change, including tasks that were not
themselves edited. The purpose of the ID is simply to enable to user,
immediately having viewed the summary output by ``vat``, to specify a
particular task for viewing or editing, as will now be described.

To display the date, summary *and detail* of a particular task, enter::

    vat [ID]

So, continuing with our example, entering ``vat 2`` will produce the following::

    2013-11-28
    A date in this ISO format represents the date the task is due.
    Put the date at the start of the first line.

To create a new task at the top of the tasks file, enter::

    vat e

This will open the tasks file in Vim_, at the first line. You can then hit
"CTRL-O" and start writing a new task at the top of the file. Be sure to leave
a single blank line between it and the next task.

To edit or delete a task::

    vat e[ID]

This will open the task file in Vim_ at the task identified by ``[ID]``. E.g.
entering ``vat e6`` will open the task file with the cursor
positioned on the task with an ID of ``6``. You then edit the text
of the task directly in Vim_, or, if desired, delete it entirely. Exit Vim_
as usual with ``x`` or ``wq``, and you're done.

The ``vat e[ID]`` invocation can also be used when you want to enter a new
task at a specific location in the file, adjacent to some existing task.
Just be sure to leave a single blank line between the new task and any
adjacent tasks.

For the sake of convention, the options detailed above also work with ``-``
prefixed before the option. E.g. ``-e``, ``-e90`` and ``90`` are all valid.
But the hyphen is entirely unnecessary. Note, however, that ``e 90`` and
``-e 90`` are not valid: the ID must not be separated from the ``e`` by
any whitespace.

Known issues
------------

``vat`` is a quick and dirty hack.

- The lines separating the tasks in the tasks file must be *completely blank*.
  If they contain whitespace then this can confuse the program. If there are
  any such "whitespace-only" lines, then ``vat`` will detect these and abort
  with an error message.
- If tasks are separated by two or more consecutive blank lines, rather than
  a single blank line, this will confuse the program when it is calculating
  the position of each task in the file. ``vat`` will not detect or warn
  about this occurring.
- ``vat`` will abort with an error message if there are 1000 or more tasks
  in the task file.

Contact
=======

You are welcome to contact me about this project at:

software@matthewharvey.net

.. References
.. _Vim: http://www.vim.org
.. _t: http://stevelosh.com/projects/t/


##
# Copyright (c) 2013, 2015 Matthew Harvey
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
##

function get_basic_usage() {
    return "Usage: vat.awk [FILE] [options]"
}

function error(message) {
    print message | "cat 1>&2"
    exit 1
}

function usage_error(message) {
    print message "\n" get_basic_usage() \
        "\nFor more detail, enter: vat.awk --help." | "cat 1>&2"
    exit 1
}

function print_help_and_exit() {
    print get_basic_usage()
    print "\nWith no options, prints summary list of tasks in FILE,",
          "sorted by due date.\n"
    print "Options:\n"
    print "  h, -h, --help      show this help message and exit"
    print "  N, -N              print full text of task with ID N"
    print "  e, -e              open FILE in Vim"
    print "  eN, -eN            edit task with ID N"
    exit
}

BEGIN {
    RS = ""; FS = "\n"

    # Note it is important that we store these regexes as strings rather
    # than as slash-delimited regex constants. See:
    #  https://www.gnu.org/software/gawk/manual/gawk.html#Using-Constant-Regexps
    date_regex = "^([1-9][0-9][0-9][0-9])-([0-1][0-9])-([0-3][0-9]) *$"
    help_regex = "^(h|-h|--help)$"

    max_tasks = 999
    max_id_width = length(max_tasks)

    if (ARGC < 2)                         usage_error("Unsufficient arguments.")
    else if (match(ARGV[1], help_regex))  print_help_and_exit()
    else if (ARGC > 3)                    usage_error("Too many arguments.")
    else if (ARGC == 3) {
        a2 = ARGV[2]
        if (match(a2, help_regex))    print_help_and_exit()
        else if (a2 ~ /^-?e$/)        exit system(sprintf("vim +0 %s", ARGV[1]))
        else if (a2 ~ /^e[0-9]+$/)    requested_id = edit_id = substr(a2, 2)
        else if (a2 ~ /^-e[0-9]+$/)   requested_id = edit_id = substr(a2, 3)
        else if (a2 ~ /^[0-9]+$/)     requested_id = detail_id = a2
        else if (a2 ~ /^-[0-9]+$/)    requested_id = detail_id = substr(a2, 2)
        else                          usage_error("Unrecognized argument: " a2)
    } else {
        print "DUE         ID SUMMARY"
    }
}

# Guard against "blank" line containing whitespace, which would mess with the
# record separation logic. Better just abort.
$0 ~ /(^|\n)[ \t]+(\n|$)/ {
    for (i in tasks) delete tasks[i]
    requested_id = 0
    error(sprintf("ERROR! Record commencing at line %d contains hidden whitespace.\n",
      line + 1))
}

NR == edit_id          { exit system(sprintf("vim %s +%d", ARGV[1], line + 1)) }

                       { line += NF + 1 }

NR == detail_id        { print $0; exit }

requested_id != 0      { next }

{
    len = length(NR)
    if (NR > max_tasks) error("Too many tasks. Cannot process safely.")
    assigned_id = NR
}

match($1, date_regex)  { s = sprintf("%s %" max_id_width ".d %s", $1, assigned_id, $2) }

!match($1, date_regex) { s = sprintf("           %" max_id_width ".d %s", assigned_id, $1) }

                       { tasks[assigned_id] = s }

END {
    if (!requested_id) {
        for (i in tasks) print(tasks[i]) | "sort -n"
    } else if (NR != requested_id) {
        error("Could not find task with ID = " requested_id)
    }
}

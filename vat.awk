##
# Copyright (c) 2013 Matthew Harvey
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

awk '

############################## WARNING! ########################################
# A single quote anywhwere in here (other than at the end) will confuse the    #
# shell!                                                                       #
################################################################################

function print_basic_usage() {
	print "Usage: vat.awk [FILE] [options]"
}

function error(message) {
	print message
	print_basic_usage()
	print "For more detail, enter: vat.awk --help."
	exit 1
}

function print_help_and_exit() {
	print_basic_usage()
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
	date_regex = /^([1-9][0-9][0-9][0-9])-([0-1][0-9])-([0-3][0-9]) *$/

	# Strange bug occurred when regex proper was used here, so storing
	# regex in a string instead.
	help_regex_s = "^(h|-h|--help)$"

	if (ARGC < 2)                           error("Unsufficient arguments.")
	else if (match(ARGV[1], help_regex_s))  print_help_and_exit()
	else if (ARGC > 3)                      error("Too many arguments.")
	else if (ARGC == 3) {
		a2 = ARGV[2]
		if (match(a2, help_regex_s))  print_help_and_exit()
		else if (a2 ~ /^-?e$/)        exit system(sprintf("vim +0 %s", ARGV[1]))
		else if (a2 ~ /^-?e[0-9]+$/)  id = edit_id = substr(a2, 2)
		else if (a2 ~ /^-?[0-9]+$/)   id = detail_id = a2
		else                          error("Unrecognized argument: " a2)
	} else {
		print "DUE         ID SUMMARY"
	}
}

# Guard against "blank" line containing whitespace, which would mess with the
# record separation logic. Better just abort.
$0 ~ /(^|\n)[ \t]+(\n|$)/ {
	printf("ERROR! Record commencing at line %d contains hidden whitespace.\n",
	  line + 1)
	for (i in tasks) delete tasks[i]
	id = 0
	exit 1
}

NR == edit_id      { exit system(sprintf("vim %s +%d", ARGV[1], line + 1))     }
                   { line += NF + 1                                            }
NR == detail_id    { print $0; exit                                            }
id != 0            { next                                                      }
$1 ~ date_regex    { s = sprintf("%s %3d %s", $1, NR, $2)                      }
$1 !~ date_regex   { s = sprintf("0          %3d %s", NR, $1)                  }
                   { tasks[NR] = s                                             }

END {
	if (!id)               for (i in tasks) print(tasks[i]) | "sort"
	else if (NR != id)     error("Could not find task with ID = " id)
}

' $*

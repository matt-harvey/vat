###
# Copyright 2013 Matthew Harvey
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
###

awk '

function print_basic_usage() {
	print "Usage: vat.awk [FILE] [options]"
}

function print_help_instruction() {
	print "For more detail, enter: vat.awk --help."
}

function error(message) {
	print message
	print_basic_usage()
	print_help_instruction()
	quick_exit = 1
	exit 1
}

function print_detailed_usage() {
	print_basic_usage()
	print "\nWith no options, prints summary list of tasks in FILE,",
	      "sorted by due date.\n"
	print "Options:\n",
	      " h, -h, --help      show this help message and exit\n",
	      " N, -N              print full text of task with ID = N\n",
	      " e, -e              open FILE in Vim\n",
	      " eN, -eN            edit task with ID = N\n"
	quick_exit = 1
	exit
}

BEGIN {
	RS = ""; FS = "\n"
	id = detail_id = edit_id = -1
	date_regex = /^([1-9][0-9][0-9][0-9])-([0-1][0-9])-([0-3][0-9])$/
	if (ARGC < 2)                          error("Unsufficient arguments.")
	else if (ARGV[1] ~ /^(h|-h|--help)$/)  print_detailed_usage()
	else if (ARGC > 3)                     error("Too many arguments.")
	else if (ARGC == 3) {
		a2 = ARGV[2]
		if (a2 ~ /^(h|-h|--help)$/)   print_detailed_usage()
		else if (a2 ~ /^-?e$/)        exit system(sprintf("vim +0 %s", ARGV[1]))
		else if (a2 ~ /^-?e[0-9]+$/)  id = edit_id = substr(a2, 2)
		else if (a2 ~ /^-?[0-9]+$/)   id = detail_id = a2
		else                          error("Unrecognized argument: " a2)
	} else {
		print "DUE         ID SUMMARY"
	}
}

NR == edit_id      { exit system(sprintf("vim %s +%d", ARGV[1], line + 1))  }
edit_id != -1      { line += NF + 1; next                                   }
NR == detail_id    { print $0; exit                                         }
detail_id != -1    { next                                                   }
$1 ~ date_regex    { s = sprintf("%s %3d %s", $1, NR, $2)                   }
$1 !~ date_regex   { s = sprintf("0          %3d %s", NR, $1)              }
                   { tasks[NR + 1] = s                                      }

END {
	if (id == -1) {
		for (task in tasks) print(tasks[task]) | "sort"
	} else if ((NR != id) && !quick_exit) {
		error("Could not find task with ID = " id)
	}
}

' $*

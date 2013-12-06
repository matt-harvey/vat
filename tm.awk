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

###
# USAGE:
#
#	tm.awk FILE
#		Print the first line of each task in the file, with its due date and
#       a generated identifier, ordered by due date. Tasks with no due date
#       have a date of "0" and are listed first.
#
#   tm.awk FILE N
#       Print the full text of the task with identifier N.
#
#	tm.awk FILE e
#       Open FILE in vim at the first line of the tasks file.
#
#   tm.awk FILE eN
#       Open FILE in vim, at the task with identifier N.
###

/usr/bin/env awk '

BEGIN {
	RS = ""; FS = "\n"
	task_to_fully_print = -1
	task_to_edit = -1
	if (ARGC > 2) {
		if (ARGV[2] ~ /^e$/) {
			exit system(sprintf("vim +0 %s", ARGV[1]))
		} else if (ARGV[2] ~ /^e/) {
			task_to_edit = substr(ARGV[2], 2)
		} else {
			task_to_fully_print = ARGV[2]
		}
	}
	printing_all = ((task_to_fully_print == -1) && (task_to_edit == -1))
}

task_to_fully_print == NR {
	print($0)
	exit
}

task_to_edit == NR {
	exit system(sprintf("vim %s +%d", ARGV[1], lines_read + 1))
}

$1 ~ /^[0-9]/ && printing_all {
	num_words = split($1, words, " ")
	s = sprintf("%s %3d  ", words[1], NR)
	for (i = 2; i <= num_words; ++i) {
		s = s sprintf("%s ", words[i])
	}
	tasks[NR + 1] = s
}

$1 !~ /^[0-9]/ && printing_all {
	tasks[NR + 1] = sprintf("0          %3d  %s", NR, $1)
}

{
	lines_read += NF + 1
}

END {
	if (printing_all) {
		for (task in tasks) print(tasks[task]) | "sort"
	}
}

' $*

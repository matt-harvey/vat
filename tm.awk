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

BEGIN {
	RS = ""; FS = "\n"
	requested_id = detail_id = edit_id = -1
	date_regex = /^([1-9][0-9][0-9][0-9])-([0-1][0-9])-([0-3][0-9]) */
	if (ARGC > 2) {
		a2 = ARGV[2]
		if (a2 ~ /^e$/)            exit system(sprintf("vim +0 %s", ARGV[1]))
		else if (a2 ~ /^e[0-9]+$/) requested_id = edit_id = substr(a2, 2)
		else if (a2 ~ /^[0-9]*$/)  requested_id = detail_id = a2
		else                   { print "Unrecognized argument: " a2; exit 1 }
	}
}

NR == edit_id      { exit system(sprintf("vim %s +%d", ARGV[1], line + 1))  }
edit_id != -1      { line += NF + 1; next                                   }
NR == detail_id    { print $0; exit                                         }
detail_id != -1    { next                                                   }
$1 ~ date_regex    { s = sprintf("%s %3d %s", $1, NR, $2)                   }
$1 !~ date_regex   { s = sprintf("0          %3d  %s", NR, $1)              }
                   { tasks[NR + 1] = s                                      }

END {
	if (requested_id == -1) {
		for (task in tasks) print(tasks[task]) | "sort"
	} else if (NR != requested_id) {
		print "Could not find task with ID = " requested_id
		exit 1
	}
}

' $*

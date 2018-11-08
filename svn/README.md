SVN tools
===

Prerequisites
---

* bash compatible shell
* svn command line tools installed

svn_diff_per_file_for_issue.sh
---

Shows all diffs where comments contain a search string, ideally a jira issue id.

	svn_diff_per_file_for_issue.sh JIRA-1234

Can be used in addition with other svn log command line options regarding limiting 
output, i.e.

	svn_diff_per_file_for_issue.sh JIRA-1234 -r12345:HEAD

svn_display_diffs.sh
---

Browse all files contained in a file that are in diff format, i.e. 

	$ svn_diff_per_file_for_issue.sh JIRA-1234
	WARNING: svn workspace may need to be updated!
	Creating diffs ...................Created file list in /tmp/files_diffed.abcdef
	Files stored in /tmp/files_diffed.abcdef:
	  1: /tmp/MODULE_DAO_src_main_java_de_blah_MyCoolClass1_java.2346827.diff
	  2: /tmp/MODULE_DAO_src_main_java_de_blah_MyCoolClass2_java.2340394.diff
	 ...
	 19: /tmp/MODULE_DAO_src_main_java_de_blah_MyCoolClass19_java.12343124.diff
	Which diff file to display [1] (e[x]it/[d]isplay file list)?
	x
	
Is used internally from `svn_diff_per_file_for_issue.sh`.
	
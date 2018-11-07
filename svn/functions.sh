function svn_files_changed_for_issue {
  local result=$(svn log -v --search ${@:-.} | grep -E '^\s+[AMR]\s' | sed -E 's/^\s+[A-Z]\s//g' | sed -E 's/\s.*$//g' | sort | uniq | grep -E '\.[a-z]+$')  
  echo $result
}

function svn_files_deleted_for_issue {
  local result=$(svn log -v --search ${@:-.} | grep -E '^\s+D\s' | sed -E 's/^\s+[A-Z]\s//g' | sort | uniq | grep -E '\.[a-z]+$')
  echo $result
}

function svn_find_rev_nos_for_issue {  
  local result=$(svn log --search ${@:-.} | grep -oE '^r[0-9]+' | sed 's/^r//g' | sort)  
  echo $result
}


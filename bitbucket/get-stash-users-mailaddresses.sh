curl -u "$user_auth" -X GET \
	-H "Accept: application/json" \
	-H "Content-Type: application/json" \
	"http://bitbucket.wkd.wolterskluwer.de/rest/api/1.0/admin/users" 2> /dev/null | \
	sed 's/\}/\n/g' | grep emailAddress | \
	sed 's/.*emailAddress\":\"//' | sed 's/",\"id\".*//' | \
	grep . | grep -v jenkins | \
	sort -fu

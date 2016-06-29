#!/bin/bash
# bveynde 2016019 mysql backup script
#

conffile='/root/bin/mysqldump.conf'
budir='/var/backups/'`hostname -s`
options='-q --opt --routines --no-create-db --hex-blob'
ts=$( date +"%Y%m%d.%H%M%S" )
mkdir -p $budir

cd $budir
echo -n "Creating backup: "
while read -r item db
do
	[[ $item = \#* ]] && continue
	[[ -z $item || -z $db ]] && continue
	[[ ! -z $1 && "x$item" != "x$1" ]] && continue
	echo -n "$item "
	#mysqldump $options --databases "$db" > dump.$item.$ts.sql
	mysqldump $options "$db" > dump.$item.$ts.sql
	gzip -9 dump.$item.$ts.sql
	md5sum dump.$item.$ts.sql.gz > dump.$item.$ts.sql.gz.md5

	dd="TEST_$db"
	mysql -e "DROP DATABASE IF EXISTS \`$dd\`; CREATE DATABASE  \`$dd\` DEFAULT CHARACTER SET latin1;"
	zcat dump.$item.$ts.sql.gz | mysql "$dd"

	ls dump.$item.*.sql*|sed -e 's/.sql\(.gz\)\{0,1\}\(.md5\)\{0,1\}$/\.\*/'|sort -r|uniq|awk 'NR>12 {print "rm "$0}'|sh  
done < "$conffile"

echo "DONE!"


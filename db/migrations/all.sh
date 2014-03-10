set -e

MYSQL_USER=testos
MYSQL_DBNAME=vorm

for relpath in $(ls ../sql/*.sql); do
  mysql -u$MYSQL_USER --password=$MYSQL_PASSWD $MYSQL_DBNAME < $relpath
done


set -e

MYSQL_USER=testos

for relpath in $(ls sql/*.sql); do
  mysql -u$MYSQL_USER --password=$MYSQL_PASS vorm_development < $relpath
done

for relpath in $(ls sql/*.sql); do
  mysql -u$MYSQL_USER --password=$MYSQL_PASS vorm_test < $relpath
done


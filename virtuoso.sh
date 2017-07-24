#!/bin/bash
cd /data

mkdir -p dumps

/config2env.py > /env.sh
source /env.sh

if [ ! -f ./virtuoso.ini ];
then
  mv /virtuoso.ini . 2>/dev/null
fi

chmod +x /clean-logs.sh
mv /clean-logs.sh . 2>/dev/null

if [ ! -f "/.config_set" ];
then
  echo "Converting environment variables to ini file"
  printenv | grep -P "^VIRT_" | while read setting
  do
    section=$(echo "$setting" | grep -o -P "^VIRT_[^_]+" | sed 's/^.\{5\}//g')
    key=$(echo "$setting" | grep -o -P "_[^_]+=" | sed 's/[_=]//g')
    value=$(echo "$setting" | grep -o -P "=.*$" | sed 's/^=//g')
    echo "Registering $section[$key] to be $value"
    crudini --set virtuoso.ini "$section" "$key" "$value"
  done
  touch /.config_set
  echo "Finished converting environment variables to ini file"
fi

if [ ! -f "/.dba_pwd_set" ];
then
  touch /sql-query.sql
  if [ "$DBA_PASSWORD" ]; then echo "user_set_password('dba', '$DBA_PASSWORD');" >> /sql-query.sql ; fi
  if [ "$SPARQL_UPDATE" = "true" ]; then echo "GRANT SPARQL_UPDATE to \"SPARQL\";" >> /sql-query.sql ; fi
  virtuoso-t +wait && isql-v -U dba -P dba < /dump_nquads_procedure.sql && isql-v -U dba -P dba < /sql-query.sql
  kill "$(pgrep '[v]irtuoso-t')"
  #touch /.dba_pwd_set
  echo "${DBA_PASSWORD:-dba}" > /.dba_pwd_set
fi

if [ -f "/.dba_pwd_set" ] && [ "$DBA_PASSWORD" ];
then
  OLD_PASSWORD=$(cat /.dba_pwd_set)
  echo "user_set_password('dba', '$DBA_PASSWORD');" > /sql-query.sql
  if [ "$SPARQL_UPDATE" = "true" ]; then echo "GRANT SPARQL_UPDATE to \"SPARQL\";" >> /sql-query.sql ; fi
  virtuoso-t +wait && isql-v -U dba -P "$OLD_PASSWORD" < /dump_nquads_procedure.sql && isql-v -U dba -P "$OLD_PASSWORD" < /sql-query.sql
  kill "$(pgrep '[v]irtuoso-t')"
  echo "${DBA_PASSWORD}" > /.dba_pwd_set
fi

if [ ! -f "/.data_loaded" ] && [ -d "toLoad" ] ;
then
    echo "Start data loading from toLoad folder"
    pwd="dba"
    # graph="http://localhost:8890/DAV"
    withoutExt=$(echo "$filename" | sed "s|\.gz$||" | sed "s|\.[a-z]*$||")
    graph=$(echo "http://$withoutExt" | sed "s|_|/|g")

    if [ "$DBA_PASSWORD" ]; then pwd="$DBA_PASSWORD" ; fi
    # if [ "$DEFAULT_GRAPH" ]; then graph="$DEFAULT_GRAPH" ; fi
    {
      echo "ld_dir('toLoad', '*', '$graph');";
      echo "rdf_loader_run();";
      echo "exec('checkpoint');";
      echo "WAIT_FOR_CHILDREN; ";
    } >> /load_data.sql
    cat /load_data.sql
    virtuoso-t +wait && isql-v -U dba -P "$pwd" < /load_data.sql
    kill "$(pgrep '[v]irtuoso-t')"
    ls -lt --time-style=long-iso ./toLoad | grep -v '^total [0-9]\+$' | awk '{ print $6, $7, $8 }' > /.data_loaded
fi

if [ -f "/.data_loaded" ] && [ -d "toLoad" ] ;
then
    echo "Check if toLoad folder contains newer files then /.data_loaded"

    for filename in ./toLoad/*
    do
        if [ /.data_loaded -ot "./toLoad/$filename" ]
        then
            echo "Load ./toLoad/$filename"

            pwd="dba"
            #graph="http://localhost:8890/DAV"
            withoutExt=$(echo "$filename" | sed "s|\.gz$||" | sed "s|\.[a-z]*$||")
            graph=$(echo "http://$withoutExt" | sed "s|_|/|g")

            if [ "$DBA_PASSWORD" ]; then pwd="$DBA_PASSWORD" ; fi
            # if [ "$DEFAULT_GRAPH" ]; then graph="$DEFAULT_GRAPH" ; fi
            {
              echo "ld_dir('toLoad', '$filename', '$graph');";
              echo "rdf_loader_run();";
              echo "exec('checkpoint');";
              echo "WAIT_FOR_CHILDREN; ";
            } > /load_data.sql
            cat /load_data.sql
            virtuoso-t +wait && isql-v -U dba -P "$pwd" < /load_data.sql
            kill "$(pgrep '[v]irtuoso-t')"

        fi
    done
    ls -lt --time-style=long-iso ./toLoad | grep -v '^total [0-9]\+$' | awk '{ print $6, $7, $8 }' > /.data_loaded
fi

virtuoso-t +wait +foreground

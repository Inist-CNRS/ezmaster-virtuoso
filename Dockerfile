FROM tenforce/virtuoso:1.3.2-virtuoso7.2.5.1

# ----------------------------------------------- #
# ezMaster configuration                          #
# ----------------------------------------------- #
EXPOSE 8890
RUN echo '{ \
  "httpPort": 8890, \
  "dataPath": "/data", \
  "configPath": "/tmp/config.json" \
}' > /etc/ezmaster.json
# ----------------------------------------------- #

# Replace tenforce's script (modified loading)
ADD virtuoso.sh /virtuoso.sh
ADD config2ini.py /config2ini.py

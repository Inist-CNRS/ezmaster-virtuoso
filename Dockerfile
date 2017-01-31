FROM tenforce/virtuoso:1.1.0-virtuoso7.2.4

# ----------------------------------------------- #
# ezMaster configuration                          #
# ----------------------------------------------- #
EXPOSE 8890
RUN echo '{ \
  "httpPort": 8890, \
  "dataPath": "/data/toLoad", \
  "configPath": "/tmp/config.json" \
}' > /etc/ezmaster.json
# ----------------------------------------------- #

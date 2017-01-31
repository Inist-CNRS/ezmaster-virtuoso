FROM tenforce/virtuoso:1.1.0-virtuoso7.2.4

# ----------------------------------------------- #
# ezMaster configuration                          #
# ----------------------------------------------- #
RUN echo '{ \
  "dataPath": "/data/toLoad" \
}' > /etc/ezmaster.json
# ----------------------------------------------- #

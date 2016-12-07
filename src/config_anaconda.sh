#!/bin/bash
#sed -i "/^PATH=.*/d" /etc/environment
#echo "PATH=/usr/bin/anaconda/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games" >> /etc/environment
#COMMENT: PATH only works for local mode, for MapReduce mode, the MapReduce mode, this setting could not work properly at all. SET property pig.streaming.udf.python.command can not work at all, really don't know why
ln -fs /usr/bin/anaconda/bin/python2.7 /usr/bin/python-anaconda

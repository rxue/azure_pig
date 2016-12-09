SET pig.streaming.udf.python.command 'python-anaconda';
rawdata = LOAD 'wasb://${container}@${storage_name}.blob.core.windows.net/dataset.csv' USING PigStorage(',') AS (dateP: chararray, webSession: chararray, cookie: chararray, sales: float);
grouped_data = GROUP rawdata BY cookie;
register 'wasb://${container}@${storage_name}.blob.core.windows.net/udf_aggregate_by_single_grouped.py' using org.apache.pig.scripting.streaming.python.PythonScriptEngine as aggrfunc;
result = FOREACH grouped_data GENERATE aggrfunc.tito(rawdata);
STORE result INTO 'wasb://${container}@${storage_name}.blob.core.windows.net/output_aggregate_by_single_grouped_${timestmp}';



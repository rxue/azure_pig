SET pig.streaming.udf.python.command 'python-anaconda';
rawdata = LOAD 'wasb://sources@pigteststorage.blob.core.windows.net/dataset.csv' USING PigStorage(',') AS (dateP: chararray, webSession: chararray, cookie: chararray, sales: float);
grouped_data = GROUP rawdata BY cookie;
register 'wasb://sources@pigteststorage.blob.core.windows.net/udf_aggregate_by_single_grouped.py' using org.apache.pig.scripting.streaming.python.PythonScriptEngine as aggrfunc;
result = FOREACH grouped_data GENERATE aggrfunc.tito(rawdata);
STORE result INTO 'wasb://sources@pigteststorage.blob.core.windows.net/output_aggregate_by_single_grouped_new';



rawdata = LOAD 'wasb://sources@pigteststorage.blob.core.windows.net/dataset.csv' USING PigStorage(',') AS (dateP: chararray, webSession: chararray, cookie: chararray, sales: float);
grouped_data = GROUP rawdata ALL;
register 'wasb://sources@pigteststorage.blob.core.windows.net/udf_aggregate_all.py' using org.apache.pig.scripting.streaming.python.PythonScriptEngine as aggrfunc;
result = FOREACH grouped_data GENERATE aggrfunc.tito(grouped_data.rawdata);
STORE result INTO 'wasb://sources@pigteststorage.blob.core.windows.net/output_aggregate_all';



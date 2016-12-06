from pig_util import outputSchema
import pandas as pd
@outputSchema("y:bag{t:tuple(cookie:chararray,sessions:int)}")
def tito(bag):
  f = pd.DataFrame(bag)
  result = f.groupby(2)[1].count().reset_index()
  result = result.iloc[[0]]
  return [tuple(i) for i in result.values]

from pig_util import outputSchema
import pandas as pd
@outputSchema("y:bag{t:tuple(cookie:chararray,sessions:int)}")
def tito(bag):
  bag.pop(0)
  f = pd.DataFrame(bag)
  result = f.groupby(2)[1].count().reset_index()
  return [tuple(i) for i in result.values]

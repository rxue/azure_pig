# azure_pig

1. Create a trial BLOB storage account
  1. Go to link: <https://azure.microsoft.com/en-us/offers/ms-azr-0044p/> to register/create a free trial account
  2. After registration, go to storage account to add a new storage account. choose **locally-redundant storage (LRS)** as the *Type*, other settings are kept as default.

2. Upload scripts and dataset to the (Blob) storage
  1. Go to the created storage account, Create a **Container**, where the pig scripts and dataset csv are uploaded to. NB! Container name can be only with lowercase
  2. Upload the script and the csv dataset to the created container

3. Create HDInsight Cluster (Linux HBase type)
  1. In the Azure portal, search with keyword "HDInsight", then HDInsight Cluster will be listed. Select it
  2. In the **New HDInsight Cluster** tab, fill in each item
    1. In the **Cluster configuration** configuration tab, choose **Spark** as *Cluster Type*, **Linux** as *Operating System*, then click *select* ref:<https://docs.microsoft.com/en-us/azure/hdinsight/hdinsight-apache-spark-overview>
    2. In the **Credentials** configuration tab, configure the required user name and password
    3. In the **Data Source** configuration tab, configure the Data Source. NB! Choose **From all subscriptions** (default) in the *Selection Method* dropbox, then choose the aforementioned already existing storage




# azure_pig

## Environment Setup

1. Create a **resource group** called *pigtest*

2. Create a trial **Blob storage account**
  1. Go to link: <https://azure.microsoft.com/en-us/offers/ms-azr-0044p/> to register/create a free trial account
  2. After registration, click the **Storage accounts** to create a new storage account. Give it a name, e.g. *pigteststorage*. Then choose **locally-redundant storage (LRS)** as the *Type* for simplicity reason, other settings are kept as default.
  3. Choose *existing* in the **Resource group** field, then select the created *pigtest* from the dropdown list

3. Upload scripts and dataset to the (Blob) storage
  1. Go to the created storage account, Create a **Container**: Click **Blobs** from the **Services**, then click **+** icon to create a container, e.g. with name *sources*, *Private* (default) as **Access type** 
  2. Upload the script and the csv dataset to the created container

4. Create **HDInsight Cluster**
  1. In the Azure portal, search with keyword "HDInsight", then HDInsight Cluster will be listed. Select it
  2. In the **New HDInsight Cluster** tab, fill in each item
    1. In the **Cluster configuration** configuration tab, choose **Spark** as *Cluster Type*, **Linux** as *Operating System*, then click *select*. (NB! The HBase system doesnot contain Anaconda, ref:<https://docs.microsoft.com/en-us/azure/hdinsight/hdinsight-apache-spark-overview>)
    2. In the **Credentials** configuration tab, configure the required user name and password
    3. In the **Data Source** configuration tab, configure the Data Source. NB! Choose **From all subscriptions** (default) in the *Selection Method* dropbox, then choose the storage created in the 2nd step and give the container's name - *sources* - created the 3rd step in the field **Choose Default Container**
    4. In the **Pricing** configuration tab, choose the amount of nodes you intend to use
    5. In the **Resource Group** tab, choose *Use existing* and then select also *pigtest* as the resource group  

5. Now that HDInsight Cluster is created, go to configure the Anaconda so that Python can have access to it
  1. Run the config_anaconda.sh through **Script Actions**

## DEMO Introduction
* **Script Action**: config_anaconda.sh
* Scripts to run in the demo: 
  * *src/aggregate_by_single_grouped.pig*
  * *src/aggregate_by_single_grouped.py*

## Automation Solution
* Billing starts once a cluster is created and stops when the cluster is deleted and is pro-rated per minute. (ref: <https://azure.microsoft.com/en-us/pricing/details/hdinsight/>)
* HDInsight cluster billing starts once a cluster is created and stops when the cluster is deleted and is pro-rated per minute, so you should always delete your cluster when it is no longer in use. (ref: <https://docs.microsoft.com/en-us/azure/hdinsight/hdinsight-delete-cluster>)

=> The whole automation process should be done with Cluster creation and deletion

### Azure CLI command to create an HDInsight cluster and run a script action:
1. Login to Azure CLI (ref: <https://docs.microsoft.com/en-us/azure/xplat-cli-connect>) 
2. `azure config mode arm`
3. `azure group create azureclitest NorthEurope`
4. Create HDInsight cluster: <https://docs.microsoft.com/en-us/azure/hdinsight/hdinsight-hadoop-create-linux-clusters-azure-cli>
  1. Create a storage account: `azure storage account create -g azureclitest --sku-name RAGRS -l NorthEurope --kind Storage azurecliteststorage`
  2. Retrieve the key used to access the storage `key1=$(azure storage account keys list -g azureclitest azurecliteststorage |grep key1 |awk '{print $3})`
  3. Create HDInsight cluster: `azure hdinsight cluster create -g azureclitest -l NorthEurope -y Linux --clusterType Spark --defaultStorageAccountName azurecliteststorage.blob.core.windows.net --defaultStorageAccountKey ${key1} --defaultStorageContainer azureclitestcluster --workerNodeCount 2 --userName admin --password 1%XabcdeX%1 --sshUserName rxue --sshPassword 1%XabcdeX%1 azureclitestcluster` 
  4. Apply a script action to a running cluster (<https://docs.microsoft.com/en-us/azure/hdinsight/hdinsight-hadoop-customize-cluster-linux>): `azure hdinsight script-action create configcluster -g azureclitest -n config_anaconda -u <scriptURI> -t headnode;workernode --persistOnSuccess`
 
## FAQ
* What is *data/simple_dataset.csv* used?
  * Used for testing in Pig in local mode as a simple test case





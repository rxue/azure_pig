#!/bin/bash
set -x
# Turn to arm mode (assume resource group - azureclitest - existed)
#azure config mode arm
# <https://docs.microsoft.com/en-us/azure/hdinsight/hdinsight-hadoop-create-linux-clusters-azure-cli>
storage_account_name=azurecliteststorage 
azure storage account create -g azureclitest --sku-name RAGRS -l NorthEurope --kind Storage ${storage_account_name}
storage_access_key=$(azure storage account keys list -g azureclitest ${storage_account_name} |grep key1 |awk '{print $3}')
export AZURE_STORAGE_ACCOUNT=${storage_account_name}
export AZURE_STORAGE_ACCESS_KEY=${storage_access_key}
container_name=blobcontainer
echo "Creating the container ${container_name}"
azure storage container create ${container_name}
azure storage blob upload /home/rxue/git/azure_pig/data/dataset.csv ${container_name} dataset.csv
azure storage blob upload /home/rxue/git/azure_pig/src/aggregate_by_single_grouped.pig ${container_name} aggregate_by_single_grouped.pig
azure storage blob upload /home/rxue/git/azure_pig/src/udf_aggregate_by_single_grouped.py ${container_name} udf_aggregate_by_single_grouped.py

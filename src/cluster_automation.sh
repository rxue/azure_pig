#!/bin/bash
set -x
script_dir=$(cd `dirname $0` && pwd)
# Turn to arm mode (assume resource group - azureclitest - existed)
resource_group=azureclitest
#azure config mode arm
# <https://docs.microsoft.com/en-us/azure/hdinsight/hdinsight-hadoop-create-linux-clusters-azure-cli>
storage_account_name=azurecliteststorage 
storage_access_key=$(azure storage account keys list -g azureclitest ${storage_account_name} |grep key1 |awk '{print $3}')
container_name=blobcontainer
cluster_name=azureclitestcluster
cluster_user=rxue
azure hdinsight cluster create -g ${resource_group} -l NorthEurope -y Linux --clusterType Spark --defaultStorageAccountName ${storage_account_name}.blob.core.windows.net --defaultStorageAccountKey ${storage_access_key} --defaultStorageContainer ${container_name} --workerNodeCount 2 --userName admin --password 1%XabcdeX%1 --sshUserName ${cluster_user} --sshPassword 1%XabcdeX%1 ${cluster_name} 
local_public_key=$(cat ~/.ssh/id_rsa.pub |awk '{print $2}')
config_script=${script_dir}/config.sh
cp ${script_dir}/config_anaconda.sh ${config_script}
echo "echo \""$(cat ~/.ssh/id_rsa.pub)"\" >> /home/${cluster_user}/.ssh/authorized_keys" >> ${config_script}
storage_access_key=$(azure storage account keys list -g azureclitest ${storage_account_name} |grep key1 |awk '{print $3}')
export AZURE_STORAGE_ACCOUNT=${storage_account_name}
export AZURE_STORAGE_ACCESS_KEY=${storage_access_key}
azure storage blob upload ${config_script} ${container_name} config.sh
rm ${config_script}
script_action_uri="https://${storage_account_name}.blob.core.windows.net/${container_name}/config.sh"
# ref: https://docs.microsoft.com/en-us/azure/hdinsight/hdinsight-hadoop-customize-cluster-linux
azure hdinsight script-action create ${cluster_name} -g ${resource_group} -n config -u ${script_action_uri} -t headnode --persistOnSuccess
azure hdinsight script-action create ${cluster_name} -g ${resource_group} -n config -u ${script_action_uri} -t workernode --persistOnSuccess
timestmp=$(date +"%Y%m%d")
ssh rxue@${cluster_name}-ssh.azurehdinsight.net 'pig -param container='${container_name}' -param storage_name='${storage_account_name}' -param timestmp='${timestmp}' wasb://'${container_name}'@'${storage_account_name}'.blob.core.windows.net/aggregate_by_single_grouped.pig'
#azure hdinsight cluster delete ${cluster_name}

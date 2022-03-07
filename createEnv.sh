. ./properties

az ad sp create-for-rbac --name $SPNAME > tmp
SPAPPID=$(jq '.appId' tmp | sed 's/^.//g;s/.$//g')
SPSECRET=$(jq '.password' tmp | sed 's/^.//g;s/.$//g')

az group create -n $RG -l $LOCATION
az aks create -g $RG -n $CLUSTER -l $LOCATION --service-principal $SPAPPID --client-secret $SPSECRET --node-count 1
az ad sp delete --id $SPAPPID 
rm tmp
az aks stop -n $CLUSTER -g $RG
az aks start -n $CLUSTER -g $RG

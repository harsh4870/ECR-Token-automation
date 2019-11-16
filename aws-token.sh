ACCOUNT=$(aws sts get-caller-identity --query 'Account' --output text) #aws account number
REGION=ap-south-1                                     #aws ECR region
SECRET_NAME=${REGION}-ecr-registry                    #secret_name
EMAIL=abc@xyz.com                                     #can be anything

TOKEN=`aws ecr --region=$REGION get-authorization-token --output text --query authorizationData[].authorizationToken | base64 -d | cut -d: -f2`

kubectl delete secret --ignore-not-found $SECRET_NAME
kubectl create secret docker-registry $SECRET_NAME \
 --docker-server=https://$ACCOUNT.dkr.ecr.${REGION}.amazonaws.com \
 --docker-username=AWS \
 --docker-password="${TOKEN}" \
 --docker-email="${EMAIL}"

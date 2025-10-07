1. Instancia de AWS 
2. Docker instalado en la VM
3. UN ARCHIVO PARA LEVANTAR EL CONTENEDOR!!!
4. Imagen de nuestra aplicacion. ECR
5. AWS CLI Instalado
6. Configurar el CLI con las credenciales
7. Iniciar sesion
8. Levantar el contened

docker-compose.yml

docker container run -d -p 80:3000 <imagen></imagen>
970547369328.dkr.ecr.us-east-2.amazonaws.com/node-711-app:latest

aws s3api create-bucket --bucket "711-tfstate-juan" \
  --region "us-east-2" \
  --create-bucket-configuration LocationConstraint="us-east-2"

aws s3api put-public-access-block --bucket "711-tfstate-juan" --public-access-block-configuration \
'{"BlockPublicAcls":true,"IgnorePublicAcls":true,"BlockPublicPolicy":true,"RestrictPublicBuckets":true}'

aws s3api put-bucket-encryption --bucket "711-tfstate-juan" --server-side-encryption-configuration \
'{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}'

aws dynamodb create-table --table-name "711-tfstate-dynamodb" \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region "us-east-2"
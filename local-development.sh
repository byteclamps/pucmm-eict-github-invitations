clear

docker container rm pucmm-eict-github-invitations -v
docker build -t pucmm-eict-github-invitations:latest -f Dockerfile .
docker run --name pucmm-eict-github-invitations -p 8080:8080 pucmm-eict-github-invitations:latest

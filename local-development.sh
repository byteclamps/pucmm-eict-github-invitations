clear

docker network create pucmm_eict_github_invitations
docker container rm pucmm-eict-github-invitations -v
docker-compose up --build

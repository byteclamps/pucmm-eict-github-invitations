FROM guhex/pucmm-eict-github-invitations.ghencon.com:latest AS runner

COPY ./pucmm-eict-github-invitations.key /etc/certificates/pucmm-eict-github-invitations.key

COPY ./pucmm-eict-github-invitations.cer /etc/certificates/pucmm-eict-github-invitations.cer


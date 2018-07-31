# rpi-gitea

```shell
version: '3.3'
services: 

  gitea: 
    image: midaug/rpi-gitea
    container_name: gitea
    restart: always
    ports:
      - "30022:22"
      - "30000:3000"
    volumes:
      - "/data/docker/gitea:/data"
```

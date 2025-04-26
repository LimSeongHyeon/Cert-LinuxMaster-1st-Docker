Build
```bash
docker build -t rocky8.8-lab .
```

Run
```bash
docker run -d --name rocky-lab --privileged -it --rm rocky8.8-lab
```

Execute
```bash
docker exec -it rocky-lab /bin/bash
```
### NOTES

- Tree directory

```bash
.
├── helm
│   ├── Chart.yaml
│   ├── README.md
│   ├── charts
│   ├── templates
│   │   ├── _helpers.tpl
│   │   ├── deployment.yaml
│   │   ├── secret_ghrc.yaml
│   │   └── secret_tele.yaml
│   └── values.yaml
├── k8s
    ├── secret-ghrc.k8s.yaml
    └── secret-tele.k8s.yaml
```

1. Add env variables to your values in `base64`:
- `export TELE_TOKEN=your bot-father token`. 
- `export GITHUB_TOKEN=your github token or your token registry`. 

2. Install helm from from local files

```bash
helm install k-bot ./helm --set secret_tele.botToken=$TELE_TOKEN --set secret_ghrc.githubToken=$GITHUB_TOKEN
```
2.1. Instal from url:

```bash
helm install kbot-v0.0.4 https://github.com/Aldans/kbot-helm-chart/releases/download/v0.0.4/helm-kbot-0.0.4.tgz --set secret_tele.botToken=$TELE_TOKEN --set secret_ghrc.githubToken=$GITHUB_TOKEN
```
- result

```bash

➜  task-5.5 git:(main) ✗ k get all -n task5-5 
NAME                                   READY   STATUS    RESTARTS   AGE
pod/k-bot-helm-kbot-564dfcb48f-5frsw   1/1     Running   0          83s

NAME                              READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/k-bot-helm-kbot   1/1     1            1           83s

NAME                                         DESIRED   CURRENT   READY   AGE
replicaset.apps/k-bot-helm-kbot-564dfcb48f   1         1         1       83s

...

➜  task-5.5 git:(main) ✗ k get secret        
NAME                          TYPE                             DATA   AGE
kbot                          Opaque                           1      94s
github-registry-secret        kubernetes.io/dockerconfigjson   1      94s
sh.helm.release.v1.k-bot.v1   helm.sh/release.v1               1      94s

```
- helm ls

```bash
➜  task-5.5 git:(main) ✗ helm ls                                                                                                  
NAME    NAMESPACE       REVISION        UPDATED                                 STATUS          CHART           APP VERSION
k-bot   task5-5         1               2023-12-18 00:49:30.352117 +0100 CET    deployed        helm-kbot-0.1.0 1.16.0     
```

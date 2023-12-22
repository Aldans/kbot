
### Simple Telegram bot "K-bot" on GoLang

Bot link on telegram t.me/odvk_bot 

#### Pre-Required 

 - go 1.20
 - git
 
For local starting need clone this repo 

```sh
git clone https://github.com/Aldans/kbot.git
```

Run command to start bot.

```sh
./kbot start
```

You can send message to bot with additional command `/start hello` bot will reply "Hello and k-bot version"

#### CI/CD

The `develop` branch has a CI/CD pipeline defined in the ".github/workflows/cicd.yaml" file and is set up to 
automatically build, push to ghrc.io, and deploy using ArgoCD to a k8s cluster after pushing a commit.

![process](https://i.imgur.com/2utXMAA.png)

**Here all steps for CI.**

![CI](https://i.imgur.com/bu7OIgl.png)

**Here all steps for CD.**

![CD](https://i.imgur.com/cQ1ewlV.png)

**Deploy kbot to k8s cluster.**

![argo](https://i.imgur.com/Yr3sjaS.png)


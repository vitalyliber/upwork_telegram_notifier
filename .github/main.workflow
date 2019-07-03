workflow "Deploy" {
  resolves = ["Run deploy script"]
  on = "push"
}

action "Run deploy script" {
  uses = "vitalyliber/dokku-github-action@master"
  env = {
    HOST = "casply.com"
    PROJECT = "upwork_notifier"
  }
  secrets = [
    "PRIVATE_KEY",
    "PUBLIC_KEY",
  ]
}

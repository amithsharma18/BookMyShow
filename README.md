# BookMyShow — End-to-End DevOps Pipeline Project

A learning project that takes a React web app (BookMyShow clone) and builds a complete
automated deployment pipeline around it using Git, Docker, Jenkins, Terraform, and Ansible.

## Architecture / Flow

```
 Developer            Git/GitHub           Jenkins              Docker Hub         AWS EC2 (via Terraform)
 ----------           ------------         --------             -----------        ------------------------
 git push    ───────▶   main branch  ───▶  Jenkins polls/   ───▶  image pushed  ───▶  Ansible pulls image
                                            webhook triggers                          & runs container
                                            build pipeline
```

1. **Git** — source code is version-controlled; pushing to `main` triggers the pipeline.
2. **Jenkins** — runs the CI/CD pipeline defined in `Jenkinsfile`: builds the Docker image,
   pushes it to Docker Hub, then triggers Ansible to deploy.
3. **Docker** — packages the React app into a portable container image.
4. **Terraform** (`terraform/`) — provisions the AWS EC2 instance that will run Jenkins,
   Docker, and the deployed app.
5. **Ansible** (`ansible/`) — configures that EC2 instance: installs Docker, installs Jenkins,
   and deploys the app container.

## Project Structure

```
Book-My-Show/
├── bookmyshow-app/          # The React application + its Dockerfile
├── terraform/               # Provisions the AWS EC2 instance + security group
│   ├── provider.tf
│   ├── variables.tf
│   ├── main.tf
│   └── outputs.tf
├── ansible/                  # Configures the EC2 instance after Terraform creates it
│   ├── ansible.cfg
│   ├── inventory.ini
│   ├── playbook.yml
│   └── roles/
│       ├── docker/          # Installs Docker Engine
│       ├── jenkins/         # Installs Jenkins + Java
│       └── app/             # Deploys the app container
├── Jenkinsfile               # CI/CD pipeline definition
└── README.md
```

## Setup Instructions

### Prerequisites
- An AWS account with an access key configured (`aws configure`)
- An existing EC2 key pair (for SSH access) — create one in the AWS console under
  EC2 → Key Pairs if you don't have one
- Terraform and Ansible installed on your **local machine** (not the EC2 box —
  they run from your laptop to set up the EC2 box)
- A Docker Hub account (free tier is fine)
- Your own fork of this repo pushed to your own GitHub account

### Step 1 — Provision infrastructure with Terraform

```bash
cd terraform
terraform init
terraform plan \
  -var="key_name=YOUR_KEY_PAIR_NAME" \
  -var="my_ip=YOUR_PUBLIC_IP/32"
terraform apply \
  -var="key_name=YOUR_KEY_PAIR_NAME" \
  -var="my_ip=YOUR_PUBLIC_IP/32"
```

Find your public IP with `curl ifconfig.me` and append `/32` to it.

Once applied, note the output `instance_public_ip` — you'll need it next.

### Step 2 — Configure the server with Ansible

Edit `ansible/inventory.ini` and replace `<EC2_PUBLIC_IP>` and `YOUR_KEY.pem` with your
actual values from Step 1.

```bash
cd ansible
ansible-playbook playbook.yml
```

This installs Docker and Jenkins on the EC2 box. At the end, it prints the initial
Jenkins admin password — save it.

### Step 3 — Set up Jenkins

1. Visit `http://<EC2_PUBLIC_IP>:8080`
2. Unlock Jenkins using the password from Step 2
3. Install suggested plugins, plus: **Docker Pipeline**, **Ansible**
4. Add Docker Hub credentials: **Manage Jenkins → Credentials**, ID = `dockerhub-creds`
5. Create a new Pipeline job pointing at your GitHub repo's `Jenkinsfile`

### Step 4 — Update the Jenkinsfile placeholders

In `Jenkinsfile`, replace:
- `YOUR_DOCKERHUB_USERNAME` with your actual Docker Hub username
- `YOUR_GITHUB_USERNAME` with your actual GitHub username

Commit and push — this triggers (or you manually trigger) the first pipeline run.

### Step 5 — Verify

- Pipeline runs in Jenkins: build → push → deploy
- App should be live at `http://<EC2_PUBLIC_IP>:3000`

## What each tool is doing here (for your own understanding)

| Tool | Role in this project |
|---|---|
| **Git/GitHub** | Stores source code; the trigger point for the whole pipeline |
| **Jenkins** | Orchestrates CI/CD — automates build, push, and deploy steps |
| **Docker** | Packages the app so it runs identically anywhere |
| **Terraform** | Defines infrastructure as code — the EC2 instance + firewall rules |
| **Ansible** | Configures software on the server — idempotent, repeatable setup |

## Notes / Things to customize

- `terraform/variables.tf` — change `instance_type` if you want a bigger/smaller box
- `ansible/playbook.yml` — `docker_image` var must match what Jenkins pushes
- This setup runs Jenkins and the app on the **same** EC2 instance for simplicity.
  A more production-like setup would separate the Jenkins server from the app server(s).

## Teardown

To avoid AWS charges when you're done experimenting:

```bash
cd terraform
terraform destroy -var="key_name=YOUR_KEY_PAIR_NAME" -var="my_ip=YOUR_PUBLIC_IP/32"
```

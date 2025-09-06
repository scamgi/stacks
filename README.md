# 🚀 My Raspberry Pi 5 Home Server Stacks

This repository contains the full configuration for my home server, running on a Raspberry Pi 5. The entire setup is managed as **Infrastructure as Code (IaC)** using Docker Compose, with the goal of being 100% reproducible, version-controlled, and easy to deploy.

## ✨ Core Principles

*   **Reproducibility:** Anyone (including my future self) should be able to redeploy the entire server from scratch just by using this repository and a simple bootstrap script.
*   **Separation of Concerns:** Configuration (this repo) is strictly separated from persistent data (which lives on an external SSD).
*   **Security First:** No secrets, passwords, or API keys are ever committed to this repository. All sensitive information is managed via `.env` files, which are ignored by Git.

---

## 🛠️ The Stack

*   **Hardware:** Raspberry Pi 5 (8GB RAM)
*   **Storage:** 1TB NVMe SSD via USB 3.0 Adapter
*   **OS:** Raspberry Pi OS Lite (64-bit)
*   **Containerization:** Docker & Docker Compose

---

## 📂 Repository Structure

The repository is organized into individual stacks, where each directory represents a service or a group of logically related services.

```
stacks/
├── .gitignore          # Ignores all .env files and sensitive data
├── nextcloud/
│   ├── docker-compose.yml
│   └── .env.template   # Template for Nextcloud environment variables
├── immich/
│   ├── docker-compose.yml
│   └── .env.template
└── ... and so on
```

---

## 🚀 How to Deploy

This guide assumes a fresh Raspberry Pi OS installation with Docker and Git installed.

### 1. Clone the Repository

```bash
git clone https://github.com/tuo-utente/stacks.git
cd stacks
```

### 2. Configure a Stack

For each service you want to launch, navigate to its directory and create your own `.env` file from the template.

**Example for Nextcloud:**

```bash
cd nextcloud
cp .env.template .env
```

Now, edit the `.env` file with your favorite editor (like `nano` or `vim`) and fill in the required values (passwords, data paths, etc.).

```bash
nano .env
```

### 3. Launch the Stack

Once the `.env` file is configured, you can start the service in detached mode (`-d`).

```bash
docker compose up -d
```

### 4. Update a Stack

To update a service to the latest image version:

```bash
# Navigate to the stack directory
cd nextcloud

# Pull the latest images specified in the docker-compose.yml
docker compose pull

# Recreate the containers with the new images
docker compose up -d
```

---

## 📦 Services Included

| Service       | Description                                      | Status      |
|---------------|--------------------------------------------------|-------------|
| **Nextcloud** | Personal cloud for file sync, contacts, and calendar. | ✅ Active   |
| **Immich**    | Self-hosted photo and video backup solution.     | ✅ Active   |
| **Pi-hole**   | Network-wide ad-blocker.                         | ✅ Active   |
| **Jellyfin**  | Open source media server.                        | 🚧 Planned  |
| **Gitea**     | Self-hosted Git service.                         | 💡 Idea     |

---

## 💾 Backup Strategy

All persistent container data is mapped to an external SSD mounted at `/mnt/ssd/data/`. This directory is **not** part of the repository. Backups of this data are handled by an external script using `restic`, which performs encrypted, deduplicated snapshots to a cloud storage provider.

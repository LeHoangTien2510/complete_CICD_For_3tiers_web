Youtube video: https://youtu.be/jYnSpkf99Do

# MERN ToDo App: CI/CD, Kubernetes, and AWS Infrastructure

![MongoDB](https://img.shields.io/badge/MongoDB-4EA94B?logo=mongodb&logoColor=white)
![Express.js](https://img.shields.io/badge/Express.js-000000?logo=express&logoColor=white)
![React](https://img.shields.io/badge/React-61DAFB?logo=react&logoColor=black)
![Node.js](https://img.shields.io/badge/Node.js-339933?logo=node.js&logoColor=white)
![Jenkins](https://img.shields.io/badge/Jenkins-CI%2FCD-D24939?logo=jenkins&logoColor=white)
![Harbor](https://img.shields.io/badge/Harbor-Registry-60B932?logo=harbor&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-Orchestration-326CE5?logo=kubernetes&logoColor=white)
![Nginx Proxy Manager](https://img.shields.io/badge/Nginx%20PM-Proxy-009639?logo=nginx&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-EC2-FF9900?logo=amazonaws&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-IaC-844FBA?logo=terraform&logoColor=white)
![Ansible](https://img.shields.io/badge/Ansible-Automation-EE0000?logo=ansible&logoColor=white)
![Prometheus](https://img.shields.io/badge/Prometheus-Monitoring-E6522C?logo=prometheus&logoColor=white)
![Grafana](https://img.shields.io/badge/Grafana-Visualization-F46800?logo=grafana&logoColor=white)

This repository contains the infrastructure as code (IaC), configuration management, and deployment manifests for a MERN-stack ToDo application. 

The project focuses on building a secure, private, and monitored DevOps environment using AWS EC2 instances. It features a private container registry (Harbor), automated builds via Jenkins, orchestration with Kubernetes, externalized MongoDB, and basic hardware monitoring using Prometheus and Grafana.

## System Architecture

The infrastructure is provisioned on AWS using Terraform. To ensure consistent IaC execution, Terraform and Ansible are packaged within a dedicated Docker container, eliminating local environment dependencies.

```mermaid
flowchart TB
    dev[🧑‍💻 Developer] -->|Push Code| git[🐙 GitHub Repository]
    git -->|Trigger| jenkins[⚙️ Jenkins CI<br/>EC2: t3.medium]
    
    subgraph CI_CD_Registry ["CI/CD & Registry"]
        npm[🛡️ Nginx Proxy Manager<br/>Handles HTTPS] --> jenkins
        npm --> harbor[🐳 Harbor Private Registry]
        jenkins -->|Push Image| harbor
    end
    
    subgraph Kubernetes_Cluster ["Kubernetes Cluster"]
        master[☸️ Master Node<br/>EC2: t3.small]
        worker1[☸️ Worker Node 1<br/>EC2: t3.small]
        worker2[☸️ Worker Node 2<br/>EC2: t3.small]
        
        master -.->|Schedule Pods| worker1 & worker2
    end
    
    jenkins -->|Apply Manifests| master
    worker1 & worker2 -->|Pull Image| harbor
    
    subgraph External_Data_Monitoring ["External Data & Monitoring"]
        mongo[(🍃 MongoDB<br/>EC2: t3.micro)]
        worker1 & worker2 -->|R/W Data| mongo
        
        prom[📊 Prometheus + Grafana<br/>EC2: t3.small]
        prom -.->|Scrape Metrics| CI_CD_Registry
        prom -.->|Scrape Metrics| master
    end
```

| Server Role | EC2 Type | Storage | Responsibility |
|---|---|---|---|
| **Jenkins & Harbor** | `t3.medium` | 30GB gp3 | Hosts the CI/CD pipeline and private container registry. Nginx Proxy Manager is used to provide HTTPS endpoints. |
| **K8s Master Node** | `t3.small` | Default | Kubernetes control plane. |
| **K8s Worker Nodes (x2)** | `t3.small` | Default | Runs the MERN application workloads. |
| **MongoDB** | `t3.micro` | Default | Dedicated external database for the application. |
| **Monitoring** | `t3.small` | Default | Runs Prometheus and Grafana to track hardware metrics. |
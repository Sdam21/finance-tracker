#Finance Tracker

A simple currency exchange rate dashboard. I built it to learn AWS and cloud infrastucture.

The app currently pulls live exchange rates from a public API and displays them in the browser.

The app was created as a way to learn how to deploy something in AWS

## BUILD
- A Flask web app running in Docker
- Deployed on AWS ECS Fargate inside a VPC configured with Terraform
- Database on RDS Postgres in a private subnet
- Credentials stored in AWS Secrets Manager
- GitHub Actions pipeline that automatically builds and deploys on every push
- CloudWatch alarms monitoring CPU and memory on both ECS and RDS

## How to run locally
```bash
python -m venv venv
venv\Scripts\activate
pip install -r requirements.txt
python app.py
```

Then open `http://localhost:5000`

## How to deploy to AWS

```bash
cd terraform
terraform init
terraform apply
```

## How to tear it down

```bash
cd terraform
terraform destroy
```

## What I learned

This was my first cloud project coming from a network engineering background. A lot of the VPC and subnet concepts translated directly from what I already knew but learning Terraform, Docker, and ECS was my main goal.

## Next steps

Not cloud related, but I would like to update this app to be a budget planner as away to get more comfortable with flask
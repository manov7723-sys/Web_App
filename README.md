<!DOCTYPE html>
<html>
<head></head>  
</head>
<body>
    <!-- Page header -->
    <header>
        <h1>Setup Repository and Files</h1>
    </header>
	1.	Download the project files from the Google Drive folder: https://drive.google.com/drive/folders/1oBLJlhq0QaSC0A3arUZwORjQOC3sRFUH?usp=sharing .

  
	2.	Install Git and Docker locally if not already done (you’ve used Docker recently on MacBook).
	3.	Clone your existing repo: `git clone https://github.com/manov7723-sys/Web_App.git`.
	4.	Enter the cloned directory: `cd Web_App`.
	5.	Copy downloaded files into this directory, then verify: `ls` (should show backend and frontend folders). 
	6.	Stage and commit changes: `git add .`, `git commit -m "Add project files"`, `git push origin main`.
  
<header>
        <h1>Backend Dockerfile</h1>
    </header>
1. Navigate to backend: `cd backend`.

2. Create `Dockerfile` with this optimized content


<img width="1440" height="900" alt="Screenshot 2025-11-28 at 00 10 27" src="https://github.com/user-attachments/assets/ac4876d5-6b6a-44cf-8f10-41711865ea29" />

<img width="1440" height="900" alt="Screenshot 2025-11-28 at 00 09 56" src="https://github.com/user-attachments/assets/5a109025-17ef-4d43-9f45-355588b29f33" />

<h3>Build image using the Dockerfile for backend<h3>

docker build -t vasanthmano/backend:latest .

<img width="1440" height="900" alt="Screenshot 2025-11-28 at 00 14 38" src="https://github.com/user-attachments/assets/319569b0-f9ea-4c02-8abc-9adb506edf50" />

Push the Docker image to Dockerhub

docker push vasanthmano/backend:latest 

<img width="1440" height="900" alt="Screenshot 2025-11-28 at 00 20 12" src="https://github.com/user-attachments/assets/870cd341-f9a1-4c0b-91ff-78c54e500bc2" />

<img width="1275" height="684" alt="Screenshot 2025-11-30 at 20 07 44" src="https://github.com/user-attachments/assets/376eeb06-2d35-46ff-9e4e-3809b2c6bbbe" /> <br><br>
  <h1>Frontend Dockerfile</h1>

  Navigate to frontend: `cd frontend`.

  Create `Dockerfile` with this optimized content

  <br><br><br>

  <img width="700" height="497" alt="Screenshot 2025-11-30 at 20 19 17" src="https://github.com/user-attachments/assets/33669379-1460-4d71-82f9-344e91728a75" />

<h3>Build the Docker imgage using the Dockerfile <h3>
  docker build -t vasanthmano/frontend:latest .

  <br><br><br>
  
  <img width="619" height="137" alt="Screenshot 2025-11-30 at 20 22 05" src="https://github.com/user-attachments/assets/601a3815-b859-441f-954a-f788478d6713" />

  <h3>Push the Docker image to DockerHub<h3>
    docker push vasanthmano/frontend:latest
<br><br><br>
  <img width="1301" height="521" alt="Screenshot 2025-11-30 at 20 06 45" src="https://github.com/user-attachments/assets/7082e9d3-d539-45e5-a540-38872df2f7ab" />  

<br><br>

Create the EC2 instance in AWS 

   • Using Ubuntu OS
   • t3.xlarge 
   • Create new key Pair
   • Ram 20GB
   • Connect the EC2 using Key pair

Install Docker and Docker compose on Ubuntu

Install Jenkins on Ubuntu

Make directory and Clone the Git Repo

  mkdir /var/lib/jenkins/workspace/Web_App1$ 

  cd /var/lib/jenkins/workspace/Web_App1$ 
  
  git clone https://github.com/manov7723-sys/Web_App.git

Change to home directory and create the Docker-Compose.yml file

  cd 

  sudo nano docker-compose.yml 

<img width="1440" height="900" alt="Screenshot 2025-11-30 at 22 32 22" src="https://github.com/user-attachments/assets/a4a0a1d0-d14e-485d-a658-65fae255761f" />

save and exit the file

ctrl+O > Enter > Ctrl+X

Change the cd to Web_App and create the Nginx config file 

cd /var/lib/jenkins/workspace/Web_App1$

sudo nano nginx/default.conf
																					
  <img width="537" height="382" alt="Screenshot 2025-11-30 at 20 23 57" src="https://github.com/user-attachments/assets/2e38b308-a63f-4e4b-9a35-cabd1117b5b3" />


  Using docker compose up command to run the conatiner locally 

  docker compose up -d 

  conform the all the container are running succefully 

  <img width="1440" height="208" alt="Screenshot 2025-11-30 at 22 48 22" src="https://github.com/user-attachments/assets/08f11f20-fe77-49e0-9df5-7d4c45cfff4d" />

  Now Remove all the  containers,volume and down the docker compose locally and Create the CI/CD pipiline.

  # 1. Basic - Stop + Remove containers/networks
docker compose down

# 2. Remove volumes too (clears MongoDB data)
docker compose down -v

# 3. Full cleanup (containers + images + volumes)
docker compose down -v --rmi all --remove-orphans

# 4. Verify clean
docker compose ps -a  # Empty table
docker ps -a          # No Web_App containers

Write the Jenkinsfile and push to GitHub Repo

ADD the port "8080" in EC2 Security group for access Jenkins
ADD the port "80" in EC2 security group for access Application
Login to JENKINS

   • Install plugins
      Manage Plugins > Install Docker plugins > Insatll Docker Compose Plugins
	  
   • Add Docker Cred
      Manage Jenkins > Credentials > Global > Add Credentials > Username - Pass - ID
	  
Create a New Build using Pipeline in JENKINS\

   • Name - Web_APP1
   • Use Pipeline Script SCM
   • Select Git 
   • Paste the GitHub Repo link
   • Add the already created Docker Credential
   • Save and Apply 

   <img width="1440" height="704" alt="Screenshot 2025-11-29 at 19 06 39" src="https://github.com/user-attachments/assets/611b9d18-d734-49c3-bf47-9664e2fce5a2" />

   • Build the Script 

<img width="1088" height="711" alt="Screenshot 2025-11-29 at 19 08 11" src="https://github.com/user-attachments/assets/93a6a3f1-1ac5-45bb-afd9-4e7c78a1dc75" />

<img width="1425" height="706" alt="Screenshot 2025-11-29 at 19 11 40" src="https://github.com/user-attachments/assets/5d03631b-d5df-473b-847f-d4852e7e0fdd" />

Verify all the Containers are Running Successfully 

Copy the IPV4 and use port 80 and access the Web_App


<img width="1308" height="726" alt="Screenshot 2025-11-30 at 22 46 38" src="https://github.com/user-attachments/assets/2e69d3cb-5a09-426d-bb35-e2c3719eb843" />

<img width="1353" height="769" alt="Screenshot 2025-11-30 at 22 46 48" src="https://github.com/user-attachments/assets/497616f8-7f2c-4943-86fa-dabca8ec0278" />





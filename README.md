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

<img width="1275" height="684" alt="Screenshot 2025-11-30 at 20 07 44" src="https://github.com/user-attachments/assets/376eeb06-2d35-46ff-9e4e-3809b2c6bbbe" />



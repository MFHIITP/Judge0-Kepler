# Important!

This code is restructured and modified, especially in the main running portions, and is different from the original code of judge0.
The judge0.conf, docker-compose.yml and the Dockerfiles are completely changed.
Added the new NGINX file, nginx.conf, and incresed the number of containers for the server to 3 from 1.
Please whosoever cloning this ensure that you have docker desktop in your machine.
# # Note - I am currently using one server and one worker container. Need to scale it once user base increases to 3 server and 2 worker components at least. 

# Important

This code is Windows Specific. Unlike the main judge0 code that is Linux / Unix specific.

# Important

Steps of execution

Start docker desktop
docker-compose down --volumes
<!-- Might take a hell lot of time, about 15 mins. Don't stop it -->
docker-compose up --build

All the secrets and passwords needed are already written. Since all these are happening in your personal machine no need to change them. If you change them no issues.
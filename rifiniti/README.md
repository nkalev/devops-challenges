## TASK
1. Create a git project into which you track your progress with commits for each step.
2. Create a production-ready task with applied all best practices
  - create vpc for production
  - create fargate service with long-running service
  - create a simple "hello world" application (bash/python/whatever)
  - service should be accessible from the Internet

3. Can you avoid creating NATs (for costs savings)?
4. As a result, provide a git repository(ies) contain the solution.

## Time accounting
1. 1h preparation work
2. 2h initial implementation of terraform and fargate
4. 3h testing and troubleshooting

## Solution
1. Docker file
2. Simple python application to show hellow world using flask framework
3. Steps to build ECR / docker image
	- Build docker image
		cmd# docker build -t hello .
	- Test run of docker image
		cmd# docker run -d -p 5000:5000 hello ( run in background )
		cmd# docker run -t -i -p 5000:5000 hello ( interactive mode )
	- Check from your browser if you can open the python app on port 5000
		cmd# http://<vm_ip>:5000/
	- Create repository
		cmd# aws ecr create-repository --repository-name hello --region eu-west-1
	- Tag docker image
		cmd# docker tag hello aws_account_id.dkr.ecr.eu-west-1.amazonaws.com/hello
	- Add login to docker config
		cmd# eval $(aws ecr get-login --no-include-email --region eu-west-1| sed 's|https://||')
	- Push docker image to repository
		cmd# docker push aws_account_id.dkr.ecr.eu-west-1.amazonaws.com/hello:latest
3. Update variables
	- Update accordingly all variables "<aws_account_id>" in file variables.tf
4. VPC with public network in 2 availability zones
5. ALB setup with port 80 as default redirecting to port 5000 internal application
6. ALB target group
7. IAM role

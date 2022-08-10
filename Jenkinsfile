pipeline{
	agent any
	stages{
		stage('Maven Test'){
			steps{
				sh 'mvn test'
			}
		}
		stage('SonarQube Analysis') {
			steps{
				withSonarQubeEnv(installationName: "SonarQube") {
					sh "mvn verify sonar:sonar -Dsonar.projectName=gateway-project-cs"
				}
			}
		}
		stage('Quality Gate') {
      		steps {
        		timeout(time: 3, unit: 'MINUTES') {
          			waitForQualityGate abortPipeline: true
        		}
      		}		
    	}
		stage('Maven Package'){
			steps{
				sh 'mvn clean package'
			}
		}
		stage('Docker Build'){
			steps{
				script{
					gateway_image = docker.build("gateway_image_cs")
				}
			}
		}
		stage('Docker Tag'){
			steps{
				script{
					gateway_image.tag(["latest"])
				}
			}
		}
		stage('Docker Push'){
			steps{
				script{
					docker.withRegistry("https://${env.AWS_ACCOUNT}.dkr.ecr.us-east-1.amazonaws.com",
							    "${env.AWS_CREDS}") {
						gateway_image.push()
					}
				}
			}
		}
		stage('ECS Run'){
			steps{
				sh "aws configure set aws_access_key_id ${env.AWS_TEAM_ACCESS_ID} --profile ecs_cs"
				sh "aws configure set aws_secret_access_key ${env.AWS_TEAM_SECRET_ID} --profile ecs_cs"
				sh "aws configure set default.region us-east-1"
				sh "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${env.AWS_ACCOUNT}.dkr.ecr.us-east-1.amazonaws.com"
				sh "export AWS_SECRET_ACCESS_KEY=${env.AWS_TEAM_SECRET_ID}"
				sh "export AWS_ACCESS_KEY_ID=${env.AWS_TEAM_ACCESS_ID}"
				sh "docker context create ecs ecs_context_cs --profile ecs_cs"
				sh "docker context use ecs_context_cs"
				sh "docker compose -p 'ecs-cs' up -d"
			}
		}
	}
	post {
		always {
			sh 'docker context use default'
			sh 'docker context rm ecs_context_cs'
			sh 'sudo docker logout'
			sh 'sudo rm -rf ~/.aws/'
			sh 'sudo rm -rf ~/jenkins/workspace/${JOB_NAME}/*'
			sh 'sudo rm -rf ~/jenkins/workspace/${JOB_NAME}/.git*'
		}
	}
}

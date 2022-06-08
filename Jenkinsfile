pipeline{
	agent any
	stages{
		stage('Maven Test'){
			steps{
				bat 'mvn test'
			}
		}
		stage('Maven Package'){
			steps{
				bat 'mvn clean package'
			}
		}
		stage('Docker Build'){
			steps{
				script{
					gateway_image = docker.build("gateway-image:0.0.1")
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
					docker.withRegistry("https://${env.AWS_ACCOUNT_NUMBER}.dkr.ecr.us-east-1.amazonaws.com",
							    'ecr:us-east-1:AWS_IAM_USER') {
						gateway_image.push('latest')
					}
				}
			}
		}
	}
}

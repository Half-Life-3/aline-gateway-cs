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
				sh "mvn sonar:sonar"
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
					docker.withRegistry("https://${env.AWS_ACCOUNT}.amazonaws.com",
							    "${env.AWS_CREDS}") {
						gateway_image.push()
					}
				}
			}
		}
	}
}

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
	}
}

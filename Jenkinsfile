pipeline{
	agent any
	stages{
		stage('Build'){
			steps{
				git branch: 'feature-HL3-179', credentialsId: 'laptop-token-2', url: 'https://github.com/Half-Life-3/aline-gateway-cs/'
				bat '''git submodule init
				git submodule sync
				git submodule update
				mvn clean package -DskipTests'''
			}
		}
		stage('Archive'){
			steps{
				archiveArtifacts artifacts: '**/target/gateway-0.0.1-SNAPSHOT.jar', fingerprint: true
			}
		}
	}
}
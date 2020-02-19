pipeline
{
    agent any
	tools
	{
		maven 'Maven'
	}
	options
    {
        timeout(time: 1, unit: 'HOURS')
		
        // Discard old builds after 5 days or 5 builds count.
        buildDiscarder(logRotator(daysToKeepStr: '5', numToKeepStr: '5'))
	  
	    //To avoid concurrent builds to avoid multiple checkouts
	    disableConcurrentBuilds()
    }
    stages
    {
	    stage ('checkout')
		{
			steps
			{
				checkout scm
			}
		}
		stage ('Build')
		{
			steps
			{
				sh "mvn install"
			}
		}
		stage ('Unit Testing')
		{
			steps
			{
				sh "mvn test"
			}
		}
		stage ('Sonar Analysis')
		{
			steps
			{
				withSonarQubeEnv("SonarQubeForAgrim") 
				{
					sh "mvn org.sonarsource.scanner.maven:sonar-maven-plugin:3.2:sonar"
				}
			}
		}
		stage ('Upload to Artifactory')
		{
			steps
			{
				rtMavenDeployer (
                    id: 'deployer',
                    serverId: '123456789@artifactory',
                    releaseRepo: 'agrimmarkan.3148133',
                    snapshotRepo: 'agrimmarkan.3148133'
                )
                rtMavenRun (
                    pom: 'pom.xml',
                    goals: 'clean install',
                    deployerId: 'deployer',
                )
                rtPublishBuildInfo (
                    serverId: '123456789@artifactory',
                )
			}
		}
		
		stage ('Docker Image')
		{
			steps
			{
				sh returnStdout: true, script: '/Applications/Docker.app/Contents/Resources/bin/docker build -t markanagrim/agrimmarkan_nagp_assignment_3148133:${BUILD_NUMBER} -f Dockerfile .'
			}
		}

		 stage ('DockerHub')
		    {
			    steps
			    {
				sh '/Applications/Docker.app/Contents/Resources/bin/docker login -u "markanagrim" -p "Canon@19sep1989" docker.io'
			    	sh returnStdout: true, script: '/Applications/Docker.app/Contents/Resources/bin/docker push markanagrim/agrimmarkan_nagp_assignment_3148133:${BUILD_NUMBER}'
			    }
		    }

		 stage ('Stop Running container')
	    	{
		        steps
		        {
		            sh '''
	                    ContainerID=$(/Applications/Docker.app/Contents/Resources/bin/docker ps | grep 7059 | cut -d " " -f 1)
	                    if [  $ContainerID ]
	                    then
	                        /Applications/Docker.app/Contents/Resources/bin/docker stop $ContainerID
	                        /Applications/Docker.app/Contents/Resources/bin/docker rm -f $ContainerID
	                    fi
	                '''
		        }
		    }

		 stage ('Docker deployment')
			{
			    steps
			    {
			        sh '/Applications/Docker.app/Contents/Resources/bin/docker run --name devopssampleapplication_agrimmarkan.3148133 -d -p 7059:8080 markanagrim/agrimmarkan_nagp_assignment_3148133:${BUILD_NUMBER}'
			    }
			}

		
		
	}
	post 
	{
        always 
		{
			echo "*********** Executing post tasks like Email notifications *****************"
        }
    }
}

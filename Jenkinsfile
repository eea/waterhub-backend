pipeline {
  agent any

  environment {
    registry = "eeacms/waterhub-backend"
    registryDevel = "eeacms/waterhub-backend-devel"
    GIT_NAME = "waterhub-backend"
    SONARQUBE_TAG = 'water.hub.copernicus.eu'
    SONARQUBE_TAG_DEMO = 'water.hub.copernicus.02pre.eea.europa.eu'   
    template = "templates/waterhub-backend"
  }

  parameters {
    string(defaultValue: '', description: 'Run tests with GIT_BRANCH env enabled', name: 'TARGET_BRANCH')
  }
  
  stages {
     stage('Build, Test & Push') {
      when {
        anyOf {
          buildingTag()
          branch 'master'
        }
      }
      steps{
        node(label: 'docker-big-jobs') {
          script {
            checkout scm
            if (env.BRANCH_NAME == 'master') {
              tagName = 'latest'
            } else {
              tagName = "$BRANCH_NAME".toLowerCase()
            }
            // build under a unique tag so the tests run on this build, never on a pulled image
            buildTag = "$tagName-build$BUILD_NUMBER"
            try {
              dockerImage = docker.build("$registry:$buildTag", "--no-cache .")
              sh "./test/run.sh $registry:$buildTag"
              docker.withRegistry( '', 'eeajenkins' ) {
                dockerImage.push(tagName)
              }
              // build devel if latest is pushed
              if (env.BRANCH_NAME == 'master') {
                dockerDevelImage = docker.build("$registryDevel:latest", "develop/.")
                docker.withRegistry( '', 'eeajenkins' ) {
                  dockerDevelImage.push()
                }
              }
            } finally {
              sh "docker rmi $registry:$buildTag $registry:$tagName $registryDevel:latest || true"
            }
          }
        }
      }
    }

    
    stage('Release on tag creation') {
      when {
        buildingTag()
      }
      steps{
        node(label: 'docker') {
          withCredentials([string(credentialsId: 'eea-jenkins-token', variable: 'GITHUB_TOKEN'),  string(credentialsId: 'waterhub-backend-trigger', variable: 'TRIGGER_MAIN_URL'), usernamePassword(credentialsId: 'jekinsdockerhub', usernameVariable: 'DOCKERHUB_USER', passwordVariable: 'DOCKERHUB_PASS')]) { //betterleaks:allow
           sh '''docker pull eeacms/gitflow; docker run -i --rm --name="$BUILD_TAG"  -e GIT_BRANCH="$BRANCH_NAME" -e GIT_NAME="$GIT_NAME" -e DOCKERHUB_REPO="$registry" -e GIT_TOKEN="$GITHUB_TOKEN" -e DOCKERHUB_USER="$DOCKERHUB_USER" -e DOCKERHUB_PASS="$DOCKERHUB_PASS"  -e TRIGGER_MAIN_URL="$TRIGGER_MAIN_URL" -e DEPENDENT_DOCKERFILE_URL="" -e GITFLOW_BEHAVIOR="RUN_ON_TAG" eeacms/gitflow'''
         }

        }
      }
    }



    stage('Update SonarQube Tags: Prod') {
      when {
        not {
          environment name: 'SONARQUBE_TAG', value: ''
        }
        buildingTag()
      }
      steps{
        node(label: 'docker') {
          withSonarQubeEnv('Sonarqube') {
            withCredentials([string(credentialsId: 'eea-jenkins-token', variable: 'GIT_TOKEN')]) {
              sh '''docker pull eeacms/gitflow'''
              sh '''docker run -i --rm --name="${BUILD_TAG}-sonar" -e GIT_NAME=${GIT_NAME} -e GIT_TOKEN="${GIT_TOKEN}" -e SONARQUBE_TAG=${SONARQUBE_TAG} -e SONARQUBE_TOKEN=${SONAR_AUTH_TOKEN} -e SONAR_HOST_URL=${SONAR_HOST_URL}  eeacms/gitflow /update_sonarqube_tags_backend.sh'''
            }
          }
        }
      }
    }

    stage('Update SonarQube Tags: Demo') {
      when {
        not {
          environment name: 'SONARQUBE_TAG_DEMO', value: ''
        }
        buildingTag()
      }
      steps{
        node(label: 'docker') {
          withSonarQubeEnv('Sonarqube') {
            withCredentials([string(credentialsId: 'eea-jenkins-token', variable: 'GIT_TOKEN')]) {
              sh '''docker pull eeacms/gitflow'''
              sh '''docker run -i --rm --name="${BUILD_TAG}-sonar" -e GIT_NAME=${GIT_NAME} -e GIT_TOKEN="${GIT_TOKEN}" -e SONARQUBE_TAG=${SONARQUBE_TAG_DEMO} -e SONARQUBE_TOKEN=${SONAR_AUTH_TOKEN} -e SONAR_HOST_URL=${SONAR_HOST_URL}  eeacms/gitflow /update_sonarqube_tags_backend.sh'''
            }
          }
        }
      }
    }
 }

  post { 
    always {
      cleanWs(cleanWhenAborted: true, cleanWhenFailure: true, cleanWhenNotBuilt: true, cleanWhenSuccess: true, cleanWhenUnstable: true, deleteDirs: true)
    }
    changed {
      script {
        def details = """<h1>${env.JOB_NAME} - Build #${env.BUILD_NUMBER} - ${currentBuild.currentResult}</h1>
                         <p>Check console output at <a href="${env.BUILD_URL}/display/redirect">${env.JOB_BASE_NAME} - #${env.BUILD_NUMBER}</a></p>
                      """
        emailext(
        subject: '$DEFAULT_SUBJECT',
        body: details,
        attachLog: true,
        compressLog: true,
        recipientProviders: [[$class: 'DevelopersRecipientProvider'], [$class: 'CulpritsRecipientProvider']]
        )
      }
    }
  }
}

$env:PATH = "$PSScriptRoot\apache-maven-3.9.6\bin;$env:PATH"

Write-Output "Starting Maven build and run..." > run_log.txt
Write-Output "Application is running. Check run_log.txt for build output or wait for server to start at http://localhost:8080"
mvn clean spring-boot:run -DskipTests >> run_log.txt 2>&1

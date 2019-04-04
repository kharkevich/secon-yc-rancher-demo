#cloud-config
packages:
  - docker.io

write_files:
  - content: |
      #!/bin/bash -x
      export curlimage=appropriate/curl
      export jqimage=stedolan/jq
      
      while true; do
        docker run --rm --net=host $curlimage -sLk https://127.0.0.1/ping && break
        sleep 5
      done
      
      # Login
      while true; do
      
          LOGINRESPONSE=$(docker run \
              --rm \
              --net=host \
              $curlimage \
              -s "https://127.0.0.1/v3-public/localProviders/local?action=login" -H 'content-type: application/json' --data-binary '{"username":"admin","password":"admin"}' --insecure)
          LOGINTOKEN=$(echo $LOGINRESPONSE | docker run --rm -i $jqimage -r .token)
          echo "Login Token is $LOGINTOKEN"
          if [ "$LOGINTOKEN" != "null" ]; then
              break
          else
              sleep 5
          fi
      done
      
      # Change password
      docker run --rm --net=host $curlimage -s 'https://127.0.0.1/v3/users?action=changepassword' -H 'content-type: application/json' -H "Authorization: Bearer $LOGINTOKEN" --data-binary '{"currentPassword":"admin","newPassword":"${admin_password}"}' --insecure
      
      # Create API key
      APIRESPONSE=$(docker run --rm --net=host $curlimage -s 'https://127.0.0.1/v3/token' -H 'content-type: application/json' -H "Authorization: Bearer $LOGINTOKEN" --data-binary '{"type":"token","description":"automation"}' --insecure)
      
      # Extract and store token
      APITOKEN=`echo $APIRESPONSE | docker run --rm -i $jqimage -r .token`
      
      # Configure server-url
      # RANCHER_SERVER="https://$(docker run --rm --net=host $curlimage -s http://169.254.169.254/latest/meta-data/local-ipv4/)"
      RANCHER_SERVER="https://${server_url}"
      docker run --rm --net=host $curlimage -s 'https://127.0.0.1/v3/settings/server-url' -H 'content-type: application/json' -H "Authorization: Bearer $APITOKEN" -X PUT --data-binary '{"name":"server-url","value":"'$RANCHER_SERVER'"}' --insecure
      
      # Create cluster
      CLUSTERRESPONSE=$(docker run --rm --net=host $curlimage -s 'https://127.0.0.1/v3/cluster' -H 'content-type: application/json' -H "Authorization: Bearer $APITOKEN" --data-binary '{"type":"cluster","rancherKubernetesEngineConfig":{"addonJobTimeout":30,"ignoreDockerVersion":true,"sshAgentAuth":false,"type":"rancherKubernetesEngineConfig","authentication":{"type":"authnConfig","strategy":"x509"},"network":{"type":"networkConfig","plugin":"canal"},"ingress":{"type":"ingressConfig","provider":"nginx"},"services":{"type":"rkeConfigServices","kubeApi":{"podSecurityPolicy":false,"type":"kubeAPIService"},"etcd":{"snapshot":false,"type":"etcdService","extraArgs":{"heartbeat-interval":500,"election-timeout":5000}}}},"name":"${cluster_name}"}' --insecure)
      
      # Extract clusterid to use for generating the docker run command
      CLUSTERID=`echo $CLUSTERRESPONSE | docker run --rm -i $jqimage -r .id`
      
      # Generate registrationtoken
      docker run --rm --net=host $curlimage -s 'https://127.0.0.1/v3/clusterregistrationtoken' -H 'content-type: application/json' -H "Authorization: Bearer $APITOKEN" --data-binary '{"type":"clusterRegistrationToken","clusterId":"'$CLUSTERID'"}' --insecure
    path: /opt/ra.sh
runcmd:
   - docker run -d --name rancher --restart=unless-stopped -p 80:80 -p 443:443 -v /opt/rancher:/var/lib/rancher rancher/rancher:${rancher_version} --acme-domain ${server_url}
   - bash /opt/ra.sh

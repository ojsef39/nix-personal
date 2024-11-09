{ lib, vars, ... }: {
  programs.ssh = {
    matchBlocks = {
      # JHC K8s
      "*.k8*.jhofer.*" = {
        user = "josef";
        passwordAuthentication = true;
        proxyCommand = "none";
        extraOptions = {
          IdentityAgent = ''"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"'';
        };
      };

      # JHC Stuff
      "10.1.1.* 10.2.2.* 136.* 2a01:4f8:171:188a::* *.jhofer.* *.cafe.local" = {
        user = "root";
        passwordAuthentication = true;
        proxyCommand = "none";
        extraOptions = {
          IdentityAgent = ''"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"'';
        };
      };

      # JHC AWS
      "*.amazonaws.com" = {
        user = "ubuntu";
        proxyCommand = "none";
        extraOptions = {
          IdentityAgent = ''"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"'';
        };
      };
    };
  };
}

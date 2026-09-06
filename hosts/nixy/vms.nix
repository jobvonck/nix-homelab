{ self, ... }:

{
  microvm = {
    stateDir = "/var/lib/microvms";

    vms = {
      test-vm = {
        flake = self;
        restartIfChanged = true;
      };
    };
  };
}

{
  programs.ssh.startAgent = true;

  services = {
    gnome.gcr-ssh-agent.enable = false;

    openssh = {
      enable = true;
      startWhenNeeded = true;
      settings = {
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "yes";
        X11Forwarding = false;
        PasswordAuthentication = false;
      };
    };
  };
}

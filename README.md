# .nix2c

## Installing
- Make sure to not run `apply_users.sh` with sudo rights
- Set the user password with `passwd` after installing

### Hardware configuration
Make sure to use the hardware configuration file that was auto generated on first boot, it's located in `/etc/nixos/hardware_configuration.nix`, this fits the specs of the current system, move it to `.nix2c/system` afterwards.

### Host-Dependent Setup
I use multiple branches for the given systems, so check out whatever branch you want for the given system.

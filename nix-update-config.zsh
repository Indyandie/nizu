#!/usr/bin/env zsh

print 'starting configuration\n'

FLAKE_FL='flake.nix'
CONF_FL='configuration.nix'
NXOS_DIR='/etc/nixos/'
KONF_DIR='/home/nizusan/konfigu/linux/nixos/'
NXOS_CONF_FL="$NXOS_DIR$CONF_FL"
NXOS_FLAKE_FL="$NXOS_DIR$FLAKE_FL"
NXOS_NIZU_DIR="${NXOS_DIR}nizu/"
NIZU_DIR='/home/nizusan/nizu/'

RM_LIST=(
    "$NXOS_CONF_FL"
    "$NXOS_FLAKE_FL"
    "$NXOS_NIZU_DIR"
)

print "\nremoving configuration files..."
for i in $RM_LIST; do
    print "rm -r $i"
    rm -r $i
done && mkdir "$NXOS_NIZU_DIR"

print "\nremoving configuration files complete"

CONF_LIST=(
    'nizu.nix'
    'hyprland.nix'
    'mb-pro.nix'
    'yubi.nix'
)

print "\ncreating hardlink: $NXOS_CONF_FL"
print "ln $KONF_DIR$CONF_FL $NXOS_CONF_FL"
ln $KONF_DIR$CONF_FL $NXOS_CONF_FL

print "\ncreating hardlink: $NXOS_FLAKE_FL"
print "ln $NIZU_DIR$FLAKE_FL $NXOS_FLAKE_FL"
ln $NIZU_DIR$FLAKE_FL $NXOS_FLAKE_FL

for ITEM in $CONF_LIST; do
    NEW_HARDLINK="$NXOS_NIZU_DIR$ITEM"
    print "\ncreating hardlink: $NEW_HARDLINK"
    print "ln $NIZU_DIR$ITEM $NEW_HARDLINK"
    ln $NIZU_DIR$ITEM $NEW_HARDLINK
done

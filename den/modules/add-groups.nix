{
  # add a quirk that allows for marking required user groups
  den.quirks.groups.description = "extra required user groups";

  # apply the groups quirk only from a user context
  # this makes it so only users that explicitly include the aspect get the group
  den.schema.user.includes = [
    ({user, ...}: {
      nixos = {groups ? [], ...}: {
        users.users.${user.name}.extraGroups = groups;
      };
    })
  ];
}

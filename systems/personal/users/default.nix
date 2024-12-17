{...}: {
  # create nixconfig group
  users.groups.nixconfig = {};

  # import all users
  imports = [
    ./ryan
  ];
}

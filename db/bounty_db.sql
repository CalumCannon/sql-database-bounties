DROP TABLE IF EXISTS bounties;
CREATE TABLE bounties(
  id SERIAL4 PRIMARY KEY,
  name VARCHAR,
  home_world VARCHAR,
  favourite_weapon VARCHAR,
  bounty_value INT
);

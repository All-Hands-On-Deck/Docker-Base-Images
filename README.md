MySQL 5.7 for Cradle PHP
============

FROM mysql:5.7

Used as a base image for Galleon.PH Projects that use [Cradle PHP](https://cradlephp.github.io/)

Sets some custom MySQL settings that Cradle uses for its setup.

This could be done in a docker-compose file but different local environment setups make this difficult to standardize to putting it into an image was the solution.


Be aware we should avoid to tests all the rake tasks. I test here the ones which are linked with the production system. Nothing like sample generation should be tested because it's actually another test, a manual one.

Also, some of the tasks are just too slow to be tested (e.g. the complete sample data destruction / creation)
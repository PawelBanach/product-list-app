# Product list app

A simple Product listing application that allows to:
* Add new product
* Edit existing product
* List all products
* Tag a product
* Delete an existing product

A product has the following structure:
* Name
* Description
* Price

## Requirements
```
Ruby v.2.4.10
Rails v.5.2.0
```

## Installation
After downloading the project install the dependencies
```
bundle install
```
Create database
```
rake db:create
```
Run migrations
```
rake db:migrate
```
Run project by
```
rails s

```

## Tests
To test project run rspec from command line
```
rspec
```
To run postman tests from command line `node` and `npm` installation is required.

Install Newman
```
npm install -g newman
```
Run Postman tests
```
newman run RoR_Interview.postman_collection.json
```

## Homework importance and expectations
- [x] Normalized database, added indexes
- [x] Validation of models
- [x] Errors handled
- [x] Transactional actions included in model methods
- [x] OOP design patterns: Service object
- [x] Test coverage
- [x] Postman tests passed
- [x] Operations compatible with requirements

## Feature optimizations and improvements
- [ ] Add pagination
- [ ] Add Redis cache
- [ ] Add Taggable Concern
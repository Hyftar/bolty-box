# Bolty Box

Built using Ruby-2.4.0 and Ruby on Rails v5.1.4

## Description

### What is Bolty-Box?
Bolty-Box is a file sharing website with its focus on simplicity and user experience.

### Installation

1. Select Ruby version 2.4.0 using RVM (Ruby Version Manager) or any other version manager
2. Install the dependencies using `bundle install`
3. Setup the database using `rails db:schema:load`
    - if developing, use `rails db:seed` to generate test file / folders structure. (***Do not use the database seeds in production since `seeds.rb` contains the passwords for users in clear text form***)
4. To setup the mailer:
    1. run `touch config/application.yml`
    2.  add the following lines to the file:
        ```yml
        gmail_username: 'example@gmail.com'
        gmail_password: 'YOUR_PASSWORD_HERE'
        ```
5. To run the server; use `rails server`
6. To run the test suite.. Well you don't. There's no test suite. We're lazy.

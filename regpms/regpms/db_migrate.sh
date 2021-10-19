docker run --rm -v $(pwd):/usr/src/app -w /usr/src/app -e RAILS_ENV=development ruby:1.9 sudo rake db:migrate

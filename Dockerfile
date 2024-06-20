FROM ruby:3.2.2

# Set environment variables
ENV RACK_ENV=production

# Install dependencies
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

# Set the working directory
WORKDIR /app

# Copy the Gemfile and Gemfile.lock
COPY Gemfile* ./

# Install gems
RUN bundle install

# Copy the rest of the application code
COPY . .

# Expose the port Puma will run on
EXPOSE 4567

# Start the application
CMD ["bundle", "exec", "puma", "-C", "puma.rb"]

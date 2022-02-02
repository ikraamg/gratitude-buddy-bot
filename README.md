[![hire-badge](https://img.shields.io/badge/Consult%20/%20Hire%20Ikraam-Click%20to%20Contact-brightgreen)](mailto:consult.ikraam@gmail.com) [![Twitter Follow](https://img.shields.io/twitter/follow/GhoorIkraam?label=Follow%20Ikraam%20on%20Twitter&style=social)](https://twitter.com/GhoorIkraam)

# Gratitude Buddy - Telegram Bot

> A Ruby-based Telegram bot was built to be a [gratitude journal](https://en.wikipedia.org/wiki/Gratitude_journal) and gratitude reminder bot. I've chosen this project due to the impact that gratitude journaling has had on my life. It has scientifically-backed evidence to show that it improves one's well being. I hope to make this bot permanently running so anyone can use it.

[Video of Presentation](https://www.loom.com/share/ac679df7d59c48bd82f977affefc8843)

![Screenshot](https://user-images.githubusercontent.com/34813339/87234247-7d890600-c3cf-11ea-983c-04f170368d07.png)

### Features

1. Allows the user to create, view and delete journal/text entries.

2. Gives scheduled reminders every 8 hours and repeats the three reminders every 24 hours. The three reminders are:

- A quote
- A reminder to write an entry into their journal.
- A reminder of what they wrote at random.

### How to use

1. Open the bot with the [gratitude_buddy_bot](http://t.me/gratitude_buddy_bot) telegram page.

2. Send the '/help' message to the bot for a list of functional details. Here is a summary:

- /start - enable notifications
- /stop - stop notifications
- /write - make an entry
- /view - view all your entries
- /delete - delete and entry
- /cancel - cancel writing or deleting
- /quote - send a quote

### How it works

The bot consists of two parts running together.
Part 1 (main.rb) waits for the messages from users and will reply.
Part 2 (scheduled.rb) send reminders to the users that have chosen to receive them.

A basic database functionality was created in the DB folder and a module (database_management.rb) was used as a mixin to give the classes control over the text files which make up the database.

There are three classes:

1. MessageResponder
This class contains all the replies that the bot will send to the user when the class is called by main.rb. This class calls the next two classes to help reply to the user.

2. StoreMessage
This class has all the methods to store journal entries from the user. It also allows the user to view their entries and delete them. A new text file is created to store each users data.

3. StateManager
This class allows the bot to know what each user would like to do. It creates a file that will record if a user would like to do any task. Such as to write or to delete or be sent scheduled messages from the bot.

## Built With

- Ruby
- Rspec(code testing)
- Rubocop(code linting)

## Demo

[Link to Bot](http://t.me/gratitude_buddy_bot)

## Getting Started

To get a local copy up and running follow these steps:

### Prerequisites

- Ruby [installed](https://www.ruby-lang.org/en/documentation/installation/) on local machine
- Forking the project
- Cloning the project to your local machine
- `cd` into the project directory
- Install the gems in the Gemfile by using the ```bundle install``` in the root folder terminal

OR, install the gems system-wide by using:

``` Ruby
  gem install telegram-bot-ruby
  gem install dotenv
  gem install rspec
```

- After intalling gems, create a .env file in your root folder and on the first line place:
```TELEGRAM_API_KEY= 'YOUR-TELEGRAM-API-KEY'```
after getting your api key by using [BotFather](https://core.telegram.org/bots) from the [Telegram API docs](https://core.telegram.org/bots)

### Usage

- Fork/Clone this project to your local machine.
- Unit tests were built in Rspec, test using ```rspec``` in root directory of the project.

## Authors

👤 **Ikraam Ghoor**

- Github: [@ikraamg](https://github.com/ikraamg)
- Twitter: [@GhoorIkraam](https://twitter.com/GhoorIkraam)
- LinkedIn: [isghoor](https://linkedin.com/isghoor)
- Email: [consult.ikraam@gmail.com](mailto:consult.ikraam@gmail.com)

## 🤝 Contributing

Contributions, issues and feature requests are welcome!

Feel free to check the [issues page](https://github.com/ikraamg/Enumerable-Methods/issues)

Start by:

- Forking the project
- Cloning the project to your local machine
- `cd` into the project directory
- Run `git checkout -b your-branch-name`
- Make your contributions
- Push your branch up to your forked repository
- Open a pull request with a detailed description to the development(or master if not available) branch of the original project for a review

## Show your support

Give a ⭐️ if you like this project!

## Acknowledgments

- The Odin project for the project plan
- Ruby [docs](https://ruby-doc.org/core-2.6.5/Enumerable.html) for detailed code behavior and tests

## 📝 License

This project is [MIT](LICENSE) licensed

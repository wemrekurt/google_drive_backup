# Google Drive Backup Script

## Preparation

This script is using google_drive gem. Please firstly install it:

```gem install google_drive```

### Configurations
Change *config.yml* file for your use!

## Installation
To use this backup script, follow these steps:

1. Go to [google_drive gem's authorization README page](https://github.com/gimite/google-drive-ruby/blob/master/doc/authorization.md) and create a new application by following the steps in guide. 
2. Go to [Google's Drive API Developer Console page](https://console.developers.google.com/apis/library/drive.googleapis.com) and authorise your application.
3. Edit the *config.json* file with the information you get from Google Developer Console.
4. Run the script with ruby: 
```ruby backup.rb```
In first time you run, it will give error, no problem, visit the URL in error message.
5. In that page, going to grant permission, **Allow** it, and copy the *key* and paste to your terminal.

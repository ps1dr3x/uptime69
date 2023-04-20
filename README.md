# Uptime 69%

## The Idea

In today's world, the one device that we always carry with us everywhere is undoubtedly our smartphone. We also tend to receive our most important alerts there. So why not use our smartphones to run our monitoring scripts directly, instead of relying on additional machines not always within our eyesight and that may sometimes break and go down too, without us noticing?

- It's the device we'll first notice when it's down and try to bring back up.
- It's where we receive our most important communications.
- If it's offline, we're offline too, so we'll not get any external monitoring alerts anyway.
- Most monitoring scripts are very simple to run and don't require many resources.
- It's decentralized: in a team for example, multiple people could run it independently and simultaneosly on their devices.
- KISS forever! 

## How it Works

The script monitors a list of services and sends a message to a Telegram chat using the Telegram API if any of the services is down. It is meant to be a general example and could easily be adapted or expanded to other types of connections and checks (of course PRs are welcome, but keep it simple).

You need to set a Telegram API token and a chat ID in the `TELEGRAM_TOKEN` and `CHAT_ID` variables, respectively. Then, create a text file called `services.txt` that contains a list of domain, port, and an (optional) string to search in the response, in the format: `<domain> <port> <search_string>`, one target per line.

For example:

```
example.com 80 text in the response
example2.com 443
example3.com 3000 other text in the response
```

Save this file in the same directory as the script, then run the script periodically using for example a crontab like:

```
*/15 * * * * bash -c "bash uptime69/uptime69.sh | tee -a uptime69/logs/uptime69.log"
```

This crontab runs every 15 minutes and appends the output to a log file.

## How to Use

1. Install a terminal emulator and *nix environment on your phone, like termux.dev with the add-on Termux:Boot, to start the cron service automatically at boot and keep it active in background.
2. Clone the repository in your phone.
3. Set your Telegram API token and chat ID in the `TELEGRAM_TOKEN` and `CHAT_ID` variables, respectively.
4. Create a `services.txt` file with the list of services to monitor.
5. Set up the crontab (`crontab -e`).
6. Enjoy the peace of mind knowing that your services are always up and running! 😎

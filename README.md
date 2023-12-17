# Uptime 69%

A simple but smart downtime monitoring system, running on your smartphone!

## The Idea

In today's world, the one device that we always carry with us is undoubtedly our smartphone. We tend to receive our most important alerts there as well. So, why not use our smartphones to run monitoring scripts directly, instead of relying on additional machines that are not so often within our eyesight and sometimes break and go down without us even noticing?

Our smartphone:

- Is a full-fledged computer in its own right, with a computing power that just a few years ago we would have dreamed of having on our desktop computers.
- Is the first device we'll notice when it's down, and it's likely the first device we'll try to bring back up ASAP.
- Is already what we use to receive our most important notifications and alerts.
- If it's offline, we're most probably offline too, so we won't receive any other external alert anyway.

Also:

- Many monitoring scripts are simple and don't require many resources to run.
- It's a "decentralized" solution: in a team, multiple people can run it independently and simultaneously on their devices, reducing the risk of a single point of failure.
- KISS forever!

## How it Works

The script monitors a list of services and sends a message to a Telegram chat (using the Telegram API) if any of the services are down. It is meant to be a general example and could easily be adapted or expanded to other types of connections and controls (of course, PRs are welcome, just keep it simple 😉).

## How to use

1. Install a terminal emulator and *nix environment on your phone. On Android, I can recommend termux.dev with the Termux:Boot add-on, that automatically starts the cron service at boot and keeps it always active in background.
2. Clone the repository or transfer the script to your phone.
3. Create the `config/config.env` file (see the example file `config/config.env.example`) and fill it with your Telegram API token and chat ID in the `TELEGRAM_TOKEN` and `CHAT_ID` variables, respectively. You can also customize the user agent via the `USER_AGENT` variable.
4. Create the `config/services.txt` file (see the example file `config/services.txt.example`) and fill it with the list of services to monitor, one per line, using the format: `<domain> <port> <search_string>`. The last parameter (optional) is a string to look for in the response (an alert is sent if the string is not found).
5. Run the script periodically by setting, for example, a crontab (`crontab -e`) like:
    ```
    # This crontab runs every 15 minutes and appends the output of the script to a log file.
    */15 * * * * bash -c "bash uptime69/uptime69.sh | tee -a uptime69/logs/uptime69.log"
    ```
6. Enjoy the peace of mind, knowing that your services will be always up and running! 😎

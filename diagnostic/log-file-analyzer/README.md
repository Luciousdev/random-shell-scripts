# Log file analyzer

This small shell script will analyze the log files in the /var/log/ and will check for the keywords "ERROR" and "WARNING"

You can change the directory it will scan in and the keywords like this:


```
log-analyzer.sh /directory/of/logs "ERROR"
```

This will check for the keyword error and in the "directory" /directory/of/logs

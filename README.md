# Start 

```
screen -S aztech
```


```
curl -O https://raw.githubusercontent.com/S4SPIDEY/aztec/refs/heads/main/aztec_setup.sh && chmod +x aztec_setup.sh && ./aztec_setup.sh
```

ctrl + A D

# Backup after 3-4 hours

```
curl -O https://raw.githubusercontent.com/S4SPIDEY/aztec/refs/heads/main/az_backup.sh && chmod +x az_backup.sh && ./az_backup.sh
```

```
[ -f "az_backup.sh" ] && rm az_backup.sh;
```

# Restart in case of crashed

```
./start_aztec_node.sh
```

# Tiny Ruby Redis Client

Need to talk to Redis but can't / don't want to add gem dependency? Just copy contents of `tiny_redis.rb` file into your script and there you have it:

```
redis = TinyRedis.new("127.0.0.1", 6379)
redis.set("foo", "bar")
redis.get("foo") # -> "bar"
redis.close
```

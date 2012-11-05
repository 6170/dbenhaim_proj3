# Design Analysis

## Overview
### Key Design Challenges
1. The relationship between a comment and its subcomments
2. Keeping track of the upvotes/downvotes
3. realtime updates for different users
4. using mongodb (and mongoid rails driver) and backbone.js

## Details
### Key Design Decisions

There are three main models that make up this project: Users, Posts, and Comments. A User can have many Posts and Comments, and an Post can have many Comments. A Comment has many Comments as well - this is what made the whole thing tricky. 

I started this project with some ambitious goals. I wanted to use mongodb and backbone.js to strengthen my skills in each. I decided to use embedded documents to represent the threaded/nested comment structure. The idea here was that everytime a comment would change we would just pass the post object back and forth. No need for recursive comment building and it would be a simple single query to get or update a post/comment. This was working fine until I hit a major bug in mongoid, the rails driver I was using for mongodb. when saving a post or updating a comment mongoid would randomly decide to work or not work. This was frustrating. I spent hours trying to figure out if it was my javascript or my rails code or my model definitions but in the end it was the driver. while the embedded document design isn't really a smart decision I was more interested in developing my skills than building a well designed app (from that perspective).

Eventually I gave up and switched to doing a more traditional associated comment system. This was relatively easy because I had all of the backbone code written and simply had to change a few minor things to get it working. 

I used pusher for the realtime updates which is basically just a websocket in javascript.   
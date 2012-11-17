## Summary assessment from user’s perspective
#### Positive
- Sexy ui 
- nested comments
- fast
- realtime updates
- user accounts

#### Negative
- Can be buggy
- Adding a comment to the page resets closes the comments
- The font and coloring choices make everything hard to read

## Summary assessment from developer’s perspective
- I tried to use mongo's embedded objects and ran into all kinds of issues
- Ended up using references 
- Did some really cool things with backbone.js
- Coupling between client and backend is a REST interface which simplifies everything
- client does most of the work



## Most and least successful decisions
### Most
Using a responsive ajax design as the main design idea
The nested backbone views are cool
runs fast
pusher makes the realtime updates simple
REST interface simplifies backend
can have as many embedded comments as you want

### Least
The errors that occur when a user isn't logged in.
UI can make the comments hard to read
Comments close when update occurs (view error)


## Analysis of design faults in terms of design principles
Didn't really intend for the app to be used by non-logged in users
I spent too much time screwing around with mongodb and embedded objects (I learned a lot)

## Priorities for improvement
1. Design for the non-logged in user's
2. Make posts and comments easier to read
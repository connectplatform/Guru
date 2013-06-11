## Session Lifecycle

A Session is created for either Operators or Visitors, and the lifecycle differs for each type of user.

When a User logs in, a Session is created or retrieved (if it already exists). This type of Session persists for longer than the lifecycle of a browser window. The Session contains information relating the User to any active ChatSessions. Users with Sessions can receive transfer requests.  Sessions also store auxiliary information such as the User's activity level (Offline, Idle, Active?). The User is Active if they have engaged in site activity "recently" [define further], and Idle if they have not "recently" but are still logged in, and are Offline is they have logged out or have closed all open browser windows. This can be tracked with a heartbeat method or by piggybacking on the WebSocket/page destruct lifecycle.

A Visitor has no User object but does have a Session. The Session object should be destroyed (left inactive?) upon closing the window/tab, or being kicked from or leaving the chat.

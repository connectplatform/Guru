###
EventEmitter v3.1.6
https://github.com/Wolfy87/EventEmitter

Oliver Caldwell (http://oli.me.uk)
Creative Commons Attribution 3.0 Unported License (http://creativecommons.org/licenses/by/3.0/)
###
((exports) ->

  # JSHint config
  #jshint devel:true

  #global define:true

  # Place the script into strict mode

  ###
  EventEmitter class
  Creates an object with event registering and firing methods
  ###
  EventEmitter = ->

    # Initialise required storage variables
    @_events = {}
    @_maxListeners = 10

  ###
  Event class
  Contains Event methods and property storage

  @param {String} type Event type name
  @param {Function} listener Function to be called when the event is fired
  @param {Object} scope Object that this should be set to when the listener is called
  @param {Boolean} once If true then the listener will be removed after the first call
  @param {Object} instance The parent EventEmitter instance
  ###
  Event = (type, listener, scope, once, instance) ->

    # Store arguments
    @type = type
    @listener = listener
    @scope = scope
    @once = once
    @instance = instance
  "use strict"

  ###
  Executes the listener

  @param {Array} args List of arguments to pass to the listener
  @return {Boolean} If false then it was a once event
  ###
  Event::fire = (args) ->
    @listener.apply @scope or @instance, args

    # Remove the listener if this is a once only listener
    if @once

      # By storing the original value we can make sure it was actually removed
      # There was a bug in which you would get an infinite loop if you called removeAllListeners from a once event
      # By doing this if the event is lost it will not make the loop go back one
      original = @instance.listeners(@type).length
      @instance.removeListener @type, @listener, @scope

      # Only return false if the length has changed
      # This is a fix for issue #26
      false  if original isnt @instance.listeners(@type).length


  ###
  Passes every listener for a specified event to a function one at a time

  @param {String} type Event type name
  @param {Function} callback Function to pass each listener to
  @return {Object} The current EventEmitter instance to allow chaining
  ###
  EventEmitter::eachListener = (type, callback) ->

    # Initialise variables
    i = null
    possibleListeners = null
    result = null

    # Only loop if the type exists
    if @_events.hasOwnProperty(type)
      possibleListeners = @_events[type]
      i = possibleListeners.length
      while i--
        result = callback.call(this, possibleListeners[i], i)
        if result is false
          i -= 1
        else break  if result is true

    # Return the instance to allow chaining
    this


  ###
  Adds an event listener for the specified event

  @param {String} type Event type name
  @param {Function} listener Function to be called when the event is fired
  @param {Object} scope Object that this should be set to when the listener is called
  @param {Boolean} once If true then the listener will be removed after the first call
  @return {Object} The current EventEmitter instance to allow chaining
  ###
  EventEmitter::addListener = (type, listener, scope, once) ->

    # Create the listener array if it does not exist yet
    @_events[type] = []  unless @_events.hasOwnProperty(type)

    # Push the new event to the array
    @_events[type].push new Event(type, listener, scope, once, this)

    # Emit the new listener event
    @emit "newListener", type, listener, scope, once

    # Check if we have exceeded the maxListener count
    # Ignore this check if the count is 0
    # Also don't check if we have already fired a warning
    if @_maxListeners and not @_events[type].warned and @_events[type].length > @_maxListeners

      # The max listener count has been exceeded!
      # Warn via the console if it exists
      console.warn "Possible EventEmitter memory leak detected. " + @_events[type].length + " listeners added. Use emitter.setMaxListeners() to increase limit."  if typeof console isnt "undefined"

      # Set the flag so it doesn't fire again
      @_events[type].warned = true

    # Return the instance to allow chaining
    this


  ###
  Alias of the addListener method

  @param {String} type Event type name
  @param {Function} listener Function to be called when the event is fired
  @param {Object} scope Object that this should be set to when the listener is called
  @param {Boolean} once If true then the listener will be removed after the first call
  ###
  EventEmitter::on = EventEmitter::addListener

  ###
  Alias of the addListener method but will remove the event after the first use

  @param {String} type Event type name
  @param {Function} listener Function to be called when the event is fired
  @param {Object} scope Object that this should be set to when the listener is called
  @return {Object} The current EventEmitter instance to allow chaining
  ###
  EventEmitter::once = (type, listener, scope) ->
    @addListener type, listener, scope, true


  ###
  Removes the a listener for the specified event

  @param {String} type Event type name the listener must have for the event to be removed
  @param {Function} listener Listener the event must have to be removed
  @param {Object} scope The scope the event must have to be removed
  @return {Object} The current EventEmitter instance to allow chaining
  ###
  EventEmitter::removeListener = (type, listener, scope) ->
    @eachListener type, (currentListener, index) ->

      # If this is the listener remove it from the array
      # We also compare the scope if it was passed
      @_events[type].splice index, 1  if currentListener.listener is listener and (not scope or currentListener.scope is scope)


    # Remove the property if there are no more listeners
    delete @_events[type]  if @_events[type] and @_events[type].length is 0

    # Return the instance to allow chaining
    this


  ###
  Alias of the removeListener method

  @param {String} type Event type name the listener must have for the event to be removed
  @param {Function} listener Listener the event must have to be removed
  @param {Object} scope The scope the event must have to be removed
  @return {Object} The current EventEmitter instance to allow chaining
  ###
  EventEmitter::off = EventEmitter::removeListener

  ###
  Removes all listeners for a specified event
  If no event type is passed it will remove every listener

  @param {String} type Event type name to remove all listeners from
  @return {Object} The current EventEmitter instance to allow chaining
  ###
  EventEmitter::removeAllListeners = (type) ->

    # Check for a type, if there is none remove all listeners
    # If there is a type however, just remove the listeners for that type
    if type and @_events.hasOwnProperty(type)
      delete @_events[type]
    else @_events = {}  unless type

    # Return the instance to allow chaining
    this


  ###
  Retrieves the array of listeners for a specified event

  @param {String} type Event type name to return all listeners from
  @return {Array} Will return either an array of listeners or an empty array if there are none
  ###
  EventEmitter::listeners = (type) ->

    # Return the array of listeners or an empty array if it does not exist
    if @_events.hasOwnProperty(type)

      # It does exist, loop over building the array
      listeners = []
      @eachListener type, (evt) ->
        listeners.push evt.listener

      return listeners
    []


  ###
  Emits an event executing all appropriate listeners
  All values passed after the type will be passed as arguments to the listeners

  @param {String} type Event type name to run all listeners from
  @return {Object} The current EventEmitter instance to allow chaining
  ###
  EventEmitter::emit = (type) ->

    # Calculate the arguments
    args = []
    i = null
    i = 1
    while i < arguments.length
      args.push arguments[i]
      i += 1
    @eachListener type, (currentListener) ->
      currentListener.fire args


    # Return the instance to allow chaining
    this


  ###
  Sets the max listener count for the EventEmitter
  When the count of listeners for an event exceeds this limit a warning will be printed
  Set to 0 for no limit

  @param {Number} maxListeners The new max listener limit
  @return {Object} The current EventEmitter instance to allow chaining
  ###
  EventEmitter::setMaxListeners = (maxListeners) ->
    @_maxListeners = maxListeners

    # Return the instance to allow chaining
    this


  ###
  Builds a clone of the prototype object for you to extend with

  @return {Object} A clone of the EventEmitter prototype object
  ###
  EventEmitter.extend = ->

    # First thing we need to do is create our new prototype
    # Then we loop over the current one copying each method out
    # When done, simply return the clone
    clone = {}
    current = @::
    key = null
    for key of current

      # Make sure this is actually a property of the object before copying it
      # We don't want any default object methods leaking though
      clone[key] = current[key]  if current.hasOwnProperty(key)

    # All done, return the clone
    clone


  # Export the class
  # If AMD is available then use it
  if typeof define is "function" and define.amd
    define ->
      EventEmitter

  # No matter what it will be added to the global object
  exports.EventEmitter = EventEmitter
) this


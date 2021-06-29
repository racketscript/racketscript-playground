#lang racketscript/base

(require racketscript/interop
         (for-syntax syntax/parse))


;;-----------------------------------------------------------------------------

(define express ($/require "express"))
(define body-parser ($/require "body-parser"))
(define child-process ($/require "child_process"))
(define https ($/require "https"))
(define url ($/require "url"))
(define session ($/require "express-session"))
(define dotenv ($/require "dotenv"))

(define spawn ($ child-process 'spawn))

(define process #js*.global.process)
(define console #js*.global.console)

;;-----------------------------------------------------------------------------

(define PORT (if ($/binop !== #js.process.env.PORT $/undefined)
                 #js.process.env.PORT
                 8080))

(#js.dotenv.config) ; load env vars from .env file

;; these are loaded from a .env file
(define PLAYGROUND-GH-CLIENT-ID #js.process.env.PLAYGROUND_GITHUB_CLIENT_ID)
(define PLAYGROUND-GH-SECRET #js.process.env.PLAYGROUND_GITHUB_SECRET)

;;-----------------------------------------------------------------------------
;; Handlers

(define (handle-save req res)
  (#js.console.log ($/binop + #js"User wants to save: " #js.req.session.id))
  (define tok #js.req.session.access_token)
  (#js.console.log ($/binop + #js"with access_token: " tok))
  ;; TODO: how to forward data directly, without re-parsing/stringifying?
  (define data (#js*.JSON.stringify #js.req.body))
  (define options
    {$/obj
     [hostname #js"api.github.com"]
     [path #js"/gists"]
     [method #js"POST"]
     [headers
      {$/obj
       ;; is this needed?
       #;[Content-Type #js"application/json"]
       #;[Content-Length #js.data.length]
       [Accept #js"application/vnd.github.v3+json"]
       [Authorization ($/binop + #js"token " #js.req.session.access_token)]
       ;; User agent required:
       ;; (from: https://docs.github.com/en/rest/overview/resources-in-the-rest-api#user-agent-required)
       ;; All API requests MUST include a valid User-Agent
       ;; header. Requests with no User-Agent header will be
       ;; rejected. We request that you use your GitHub username, or
       ;; the name of your application, for the User-Agent header
       ;; value. This allows us to contact you if there are problems.
       [User-Agent #js"RacketScript Playground"]}]})
  (define gh-req
    (#js.https.request
     options
     (λ (gh-res)
       (#js.console.log ($/binop + #js"statusCode: " #js.gh-res.statusCode))
       (define gh-datas ($/array)) ; array of partial data buffers
       ;; TODO: is there a more high level way to get the data?
       ;; https://stackoverflow.com/questions/40537749/how-do-i-make-a-https-post-in-node-js-without-any-third-party-module
       (#js.gh-res.on #js"data" (λ (chunk) (#js.gh-datas.push chunk)))
       (#js.gh-res.on #js"end"
        (λ ()
          (define gh-data (#js*.Buffer.concat gh-datas))
          ;; TODO: directly convert data to JSON?
          (define res-data (#js*.JSON.parse (#js.gh-data.toString)))
          (define gist-id #js.res-data.id)
          (#js.console.log ($/binop + #js"save successful, gist id: " gist-id))

          ;; now make second api call to patch the description,
          ;; to include a direct link to open gist in playground app
          (define patch-data
            (#js*.JSON.stringify
             {$/obj
              [description
               ($/binop +
                #js"RacketScript Playground Program; view at: http://dev.racketscript.org:8080/#gist/"
                gist-id)]}))

          (define patch-options
            {$/obj
             [hostname #js"api.github.com"]
             [path ($/binop + #js"/gists/" gist-id)]
             [method #js"PATCH"]
             [headers
              {$/obj
               [Accept #js"application/vnd.github.v3+json"]
               [Authorization ($/binop + #js"token " #js.req.session.access_token)]
               ;; User agent required:
               ;; (see: https://docs.github.com/en/rest/overview/resources-in-the-rest-api#user-agent-required)
               [User-Agent #js"RacketScript Playground"]}]})

          (define patch-req (#js.https.request patch-options))
          (#js.patch-req.on #js"error" (λ (e) (#js.console.error e)))
          (#js.patch-req.write patch-data)
          (#js.patch-req.end)

          ;; finally, return gist-id to client
          (#js.res.send gist-id))))))
  (#js.gh-req.on #js"error"
   (λ (e)
     (#js.console.error e)))

  (#js.gh-req.write data)
  (#js.gh-req.end))

(define (query-login req res)
  (#js.console.log (js-string (format "User ~a checking login status ..." (js-string->string #js.req.session.id))))
  (#js.res.send ($/binop !== #js.req.session.access_token $/undefined)))

(define (handle-logout req res)
  (#js.console.log (js-string (format "User ~a wants to log out ..." (js-string->string #js.req.session.id))))
  (#js.req.session.destroy
   (λ (err)
     (if ($/binop !== err $/undefined)
         ($> (#js.res.status 400)
             (send #js"Unable to log out"))
         (#js.res.send #js"Logout successful")))))

;; ##### gh login steps: #####
;; 1) user clicks login button:
;;    - pop up new window
;;    - send "/login" request to server
;; 2) server `handle-login` fn called
;;    - calls gh outh link with
;;      - gh Playground App Client ID
;;      - user session id (generated by express-session library)
;;    - user gets prompted to enter gh credentials
;; 3) user logs in to gh
;;    - gh calls server callback route (as registered with gh Playground App)
;;    - gh makes server "/auth" post request
;; 4) server `handle-auth` fn called (see below)
;;    - extract "code" from gh request
;;    - send code, App client id, and app client secret to gh to get access token
;;      (the server must do this request bc client will get blocked by browser CORS policy)
;;    - add access token to users's session in sessionStore (part of express-session)
;;      (TODO: dont use the default store)
;;      (session id was returned as param with gh request)
;;    - send response to user to close login window,
;;      and update buttons to reflect logged in status
(define (handle-login req res)
  (#js.console.log ($/binop + #js"User wants to login, id: " #js.req.session.id))
  ($/:= #js.req.session.access_token #js"") ; initialize field so session gets saved to store
  (#js.console.log #js"Initiating GH Auth request ...")
  (define params
    ($/new
     (#js.url.URLSearchParams
      {$/obj
       [client_id PLAYGROUND-GH-CLIENT-ID]
       [scope #js"gist"]
       [state #js.req.session.id]})))
  (define gh-auth-url
    ($/binop + #js"https://github.com/login/oauth/authorize?" params))
  (#js.console.log ($/binop + #js"redirecting user to:\n" gh-auth-url))
  (#js.res.redirect 302 gh-auth-url))
  
;; OAuth steps:
;; 1) User initiates login by clicking "login" button, client_id sent to gh
;; 2) github calls this handler with a "code"
;; 3) server calls github authorize with:
;; - code
;; - client_id
;; - client secret
;; 4) gh responds with auth token
;; 5) send auth token in header with every gh api call
;; NOTE: the client_id comes from creating github oauth app;
;;       handler url "racketscript.org/auth" must be registered on this app page
(define (handle-auth req res)
  (#js.console.log #js"User logged in, attempting to get GH access token ...")
  (#js.console.log ($/binop + #js"with user id: " #js.res.req.query.state))
  (#js.console.log ($/binop + #js"and code: " #js.res.req.query.code))

  (define code #js.res.req.query.code)

  (define data
    (#js*.JSON.stringify
     {$/obj
      [client_id PLAYGROUND-GH-CLIENT-ID]
      [client_secret PLAYGROUND-GH-SECRET]
      [code code]}))
  (define options
    {$/obj
     [hostname #js"github.com"]
     [path #js"/login/oauth/access_token"]
     [method #js"POST"]
     [headers
      {$/obj
       [Content-Type #js"application/json"]
       [Content-Length #js.data.length]}]})
  (define gh-req
    (#js.https.request
     options
     (λ (gh-res)
       (#js.console.log ($/binop + #js"access_token request statusCode: " #js.gh-res.statusCode))
       (#js.gh-res.on #js"data"
        (λ (d) ;; data buffer
          (define params ($/new (#js.url.URLSearchParams (#js.d.toString #js"utf8"))))
          (define tok (#js.params.get #js"access_token"))
          (#js.console.log ($/binop + #js"Received GH access_token: " tok))
          ($/:= #js.req.session.access_token tok)
          (#js.console.log ($/binop + #js"stored access_token: " #js.req.session.access_token))
          (#js.console.log ($/binop + #js"for user id: " #js.req.session.id))
          ;; TODO: Is there a better way to do this?
          ;; send message to main window, to reflect logged in status; close gh login window
          (#js.res.send
           #js"<script>window.opener.postMessage('logged-in', window.location.origin);window.close()</script>")
          )))))
  (#js.gh-req.on #js"error"
   (λ (e)
     (#js.console.error e)))

  (#js.gh-req.write data)
  (#js.gh-req.end))


(define (handle-compile req res)
  (define racket-code (or ($ req 'body 'code) #f))

  (cond
    [racket-code
     (#js.console.log #js"Compiling request.")

     (define racks (spawn #js"racks"
                            [$/array #js"-n"
                                     #js"--js"
                                     #js"--stdin"
                                     #js"--enable-self-tail"]))

     (define output #js"")
     (define err    #js"")

     ;; Write to process input stream, followed by closing it
     ;; so that we get output
     (#js.racks.stdin.write racket-code)
     (#js.racks.stdin.end)

     (#js.racks.stdout.on #js"data"
       (λ (data)
         ($/:= output ($/binop + output data))))

     (#js.racks.stderr.on #js"data"
       (λ (data)
         ($/:= err ($/binop + err data))))

     (#js.racks.on #js"error"
       (λ (err)
         (#js.res.send #js"Error invoking compiler.")))

     (#js.racks.on #js"close"
       (λ (code)
         (cond
           [(equal? code 0)
            (#js.res.status 200)
            (#js.res.send output)]
           [else
            (#js.res.status 400)
            (#js.res.send err)])))]
    [else
     ($> (#js.res.status 400)
         (send #js"Bad Request"))]))

;;-----------------------------------------------------------------------------

(define (main)
  (define app (express))

  (#js.app.use (#js.express.static #js"static"))
  (#js.app.use #js"/examples" (#js.express.static #js"examples"))

  (#js.app.use (#js.body-parser.urlencoded {$/obj [extended #t] ; must be #t for nested objs (see save code)
                                                  [limit #js"8mb"]}))
  (#js.app.use (#js.body-parser.json {$/obj [limit #js"8mb"]}))

  ;; TODO: not supposed to use the default sessionStore
  (#js.app.use (session {$/obj [secret #js"RacketScript PlayGround"]
                               [resave #f]
                               [saveUninitialized #f]}))

  (#js.app.get #js"/auth" handle-auth)
  
  (#js.app.get #js"/login" handle-login)
  (#js.app.get #js"/logout" handle-logout)
  (#js.app.get #js"/isloggedin" query-login)
  
  (#js.app.post #js"/compile" handle-compile)
  
  (#js.app.post #js"/save" handle-save)

  (#js.app.listen PORT
      (λ ()
        (#js.console.log #js"Starting playground at port" PORT)))

  (void))

(main)

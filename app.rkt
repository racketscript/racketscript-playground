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

;; (define PLAYGROUND-GH-CLIENT-ID #js"079bd6bc167ef3ba0753")
;; (define PLAYGROUND-GH-SECRET #js"d0beada041f11935c6e27acd3e34566b6548b72a")
(define PLAYGROUND-GH-CLIENT-ID #js.process.env.PLAYGROUND_GITHUB_CLIENT_ID)
(define PLAYGROUND-GH-SECRET #js.process.env.PLAYGROUND_GITHUB_SECRET)

;;-----------------------------------------------------------------------------
;; Handlers

(define (has-code? url) (#js.url.includes #js"?code="))

(define (url->code uu)
  (#js.console.log ($/binop + #js"extracting code from: " uu))
  (define u ($/new (#js.url.URL uu)))
  (#js.console.log #js.u.searchParams)
  (#js.console.log (#js.u.searchParams.get #js"code"))
  (#js.u.searchParams.get #js"code"))
;  ($ (#js.url.split #js"?code=") 1))

(define (handle-save req res)
  (#js.console.log ($/binop + #js"User wants to save: " #js.req.session.id))
  (#js.console.log #js.req.session)
  (define tok #js.req.session.access_token)
  (#js.console.log ($/binop + #js"access_token: " tok))
#;  (define data
    {$/obj
     [public      #t]
#;     [files
      (assoc->object
       `([,*gist-source-file* ,{$/obj
                                [content (#js.cm-editor-racket.getValue)]}]
         [,*gist-javascript-file* ,{$/obj
                                    [content (#js.cm-editor-jsout.getValue)]}]))]
     [files
      {$/obj
       [source.rkt {$/obj
                    [content (#js.cm-editor-racket.getValue)]}]
       [compiled.js {$/obj
                     [content (#js.cm-editor-jsout.getValue)]}]}]})
  ;; (define settings
  ;;   {$/obj
  ;;    [url #js"https://api.github.com/gists"]
  ;;    [data #js.req.data]
  ;;    [headers
  ;;     {$/obj
  ;;      [Accept #js"application/vnd.github.v3+json"]
  ;;      [Authorization #js.req.session.access_token]}]})
  ;; ($> (#js.jQuery.post settings)
  ;;     (done (λ (data)
  ;;             (#js.console.log #js.data.id)
  ;; #;            (define id #js.data.id)
  ;;   #;          (:= #js.window.location.href ($/binop + #js"#gist/" id))))
  ;;     (fail (λ (e)
  ;;             (#js.console.log #js.e)
  ;;             #;(show-error "Error saving as Gist"
  ;;                         #js.e.responseJSON.message)))))
  ;; TODO: can we just forward data directly, without re-parsing/stringifying?
  (define data (#js*.JSON.stringify #js.req.body))
  (define options
    {$/obj
     [hostname #js"api.github.com"]
     [path #js"/gists"]
     [method #js"POST"]
     [headers
      {$/obj
       [Accept #js"application/vnd.github.v3+json"]
       [Authorization ($/binop + #js"token " #js.req.session.access_token)]
#;       [Content-Type #js"application/json"]
  #;     [Content-Length #js.data.length]
       ;; from: https://docs.github.com/en/rest/overview/resources-in-the-rest-api#user-agent-required
       ;; User agent required:
       ;; All API requests MUST include a valid User-Agent
       ;; header. Requests with no User-Agent header will be
       ;; rejected. We request that you use your GitHub username, or
       ;; the name of your application, for the User-Agent header
       ;; value. This allows us to contact you if there are problems.
       [User-Agent #js"RacketScript Playground"]
       }]})
  (define gh-req
    (#js.https.request
     options
     (λ (gh-res)
       (#js.console.log ($/binop + #js"statusCode: " #js.gh-res.statusCode))
       (#js.console.log ($/binop + #js"headers: " #js.gh-res.headers))
       (#js.console.log (#js*.JSON.stringify #js.gh-res.headers))
       (define gh-datas ($/array)) ; array of partial data buffers
       ;; TODO: is there a more high level way to get the data?
       ;; https://stackoverflow.com/questions/40537749/how-do-i-make-a-https-post-in-node-js-without-any-third-party-module
       (#js.gh-res.on #js"data" (λ (chunk) (#js.gh-datas.push chunk)))
       (#js.gh-res.on #js"end"
        (λ ()
          (define gh-data (#js*.Buffer.concat gh-datas))
          ;; TODO: directly convert data to JSON?
          (define res-data (#js*.JSON.parse (#js.gh-data.toString)))
          (#js.console.log #js.res-data.id)
          (#js.res.send #js.res-data.id)
#;          (#js.process.stdout.write d)
          ;; (define params ($/new (#js.url.URLSearchParams (#js.d.toString #js"utf8"))))
          ;; (#js.console.log #js.params)
          ;; (define tok (#js.params.get #js"access_token"))
          ;; (#js.console.log ($/binop + #js"Received GH access_token: " tok))
          ;; (#js.console.log ($/binop + #js"user id: " #js.req.session.id))
          ;; (#js.console.log ($/binop + #js"stored access_token (before): " #js.req.session.access_token))
          ;; ($/:= #js.req.session.access_token tok)
          ;; (#js.console.log ($/binop + #js"stored access_token: " #js.req.session.access_token))
          ;; (#js.req.session.save (λ (e) (#js.console.log #js"access_token saved")))
          ;; (#js.console.log #js.req.session)
           ;; (#js.res.send #js"<script>window.close();</script>")
          ;; (set! ACCESS-TOKEN tok))))))
          )))))
  (#js.gh-req.on #js"error"
   (λ (e)
     (#js.console.error e)))

  (#js.gh-req.write data)
  (#js.gh-req.end))

(define (query-login req res)
  (#js.console.log (js-string (format "User ~a checking login status ..." (racket-string #js.req.session.id))))
  (#js.console.log #js.req.session)
  (#js.console.log #js.req.session.access_token)
  (#js.res.send ($/binop !== #js.req.session.access_token $/undefined)))

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
;; 4) server `handle-auth` fn called
;;    - extract "code" from gh request
;;    - send code, App client id, and app client secret to gh to get access token
;;    - add access token to users's session in sessionStore (part of express-session)
;;      (TODO: dont use the default store)
;;      (session id was returned as param with gh request)
;;    - send response to user to close login window,
;;      and update buttons to reflect logged in status
(define (handle-login req res)
  (#js.console.log ($/binop + #js"User id wants to login: " #js.req.session.id))
  (#js.console.log ($/binop + #js"User id wants to login: " #js.req.session.id))
  ($/:= #js.req.session.access_token #js"") ; initialize so session gets saved
  (#js.console.log #js.req.session)
  (#js.console.log #js"Initiating GH Auth request ...")
  (define params
    ($/new
     (#js.url.URLSearchParams
      {$/obj
       [client_id PLAYGROUND-GH-CLIENT-ID]
       [scope #js"gist"]
       [state #js.req.session.id]})))
  (#js.console.log    ($/binop + #js"https://github.com/login/oauth/authorize?" params))
  (#js.res.redirect
   302
   ($/binop + #js"https://github.com/login/oauth/authorize?" params))
;; client_id=079bd6bc167ef3ba0753&scope=gist")
;;   (define data
;;     (#js*.JSON.stringify
;;      {$/obj
;;       [client_id PLAYGROUND-GH-CLIENT-ID]
;; #;      [client_secret CLIENT-SECRET]
;;   #;    [code code]}))
;;   (define options
;;     {$/obj
;;      [hostname #js"github.com"]
;;      [path #js"/login/oauth/authorize??client_id=079bd6bc167ef3ba0753&scope=gist"]
;;      [method #js"GET"]
;; #;     [headers
;;       {$/obj
;;        [Content-Type #js"application/json"]
;;        [Content-Length #js.data.length]}]})
;;   (define gh_auth_req
;;     (#js.https.request
;;      options
;;      (λ (gh_auth_res)
;;        (#js.console.log #js"github response ...")
;;        (#js.gh_auth_res.on #js"data"
;;         (λ (d) ;; data buffer
;;           ;; (#js.process.stdout.write d)
;;           ;; (#js.console.log ($/typeof d))
;;           ;; TODO: should be able to send buffer directly without converting to string?
;;           ;; must set Content-Type to "text/html"?
;;           ;; When the parameter is a Buffer object, the method sets the Content-Type response header field to “application/octet-stream”, unless previously defined as shown below: res.set('Content-Type', 'text/html')
;;           ;; https://expressjs.com/en/api.html#res
;;           (define str (#js.d.toString #js"utf8"))
;;           (#js.console.log str)
;;           (#js.res.set #js"Content-Type" #js"text/html; charset=UTF-8") ; otherwise gets treated as plain text
;; ;          (#js.res.send #js"<html><body>you are being <a href='https://google.com'>redirected</a><body></html>")
;;           (#js.res.send str)
;;           ;; (define params ($/new (#js.url.URLSearchParams (#js.d.toString #js"utf8"))))
;;           ;; (#js.console.log #js.params)
;;           ;; (define tok (#js.params.get #js"access_token"))
;;           ;; (#js.console.log ($/binop + #js"Received GH access_token: " tok))
;;           ;; (set! ACCESS-TOKEN tok))))))
;;           )))))
;;   (#js.gh_auth_req.on #js"error"
;;    (λ (e)
;;      (#js.console.error e)))
;;   (#js.gh_auth_req.end)
)  
  ;;      (#js.console.log ($/binop + #js"statusCode: " #js.res.statusCode))
  ;;      (#js.console.log ($/binop + #js"headers: " #js.res.headers))
  ;;      (#js.console.log (#js*.JSON.stringify #js.res.headers))
  ;;      (#js.res.on #js"data"
  ;;       (λ (d) ;; data buffer
  ;;         (#js.process.stdout.write d)
  ;;         (define params ($/new (#js.url.URLSearchParams (#js.d.toString #js"utf8"))))
  ;;         (#js.console.log #js.params)
  ;;         (define tok (#js.params.get #js"access_token"))
  ;;         (#js.console.log ($/binop + #js"Received GH access_token: " tok))
  ;;         (set! ACCESS-TOKEN tok))))))
  ;; (#js.req.on #js"error"
  ;;  (λ (e)
  ;;    (#js.console.error e)))
  ;;           <!-- <li><a href="#" target="popup" onclick="window.open('https://github.com/login/oauth/authorize?client_id=079bd6bc167ef3ba0753&scope=gist','popup','width=600,height=800'); return false;" id="btn-login"><span class="glyphicon glyphicon-log-in" aria-hidden="true" target="blank"></span> Log in</a></li> -->

  
  
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
  (#js.console.log #js"Making GH Auth request ...")
  ;;      (#js.console.log #js.res.req)
  (#js.console.log #js.res.req.query.code)
  (#js.console.log #js.res.req.query.state)
#;  (define sess
    (#js.res.req.session.store.get
     #js.res.req.query.state
     (λ (e sid)
       (#js.console.log
        ($/binop + #js"ERR, session not found: " sid)))))
;;  (define code (url->code #js.res.req.url))
  (define code #js.res.req.query.code)
  (#js.console.log ($/binop + #js"Received GH code: " code))

  (#js.console.log #js"Making GH Access Token request ...")
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
       ;; (#js.console.log #js.gh-res)
       (#js.console.log ($/binop + #js"statusCode: " #js.gh-res.statusCode))
       (#js.console.log ($/binop + #js"headers: " #js.gh-res.headers))
       (#js.console.log (#js*.JSON.stringify #js.gh-res.headers))
       (#js.gh-res.on #js"data"
        (λ (d) ;; data buffer
          (#js.process.stdout.write d)
          (define params ($/new (#js.url.URLSearchParams (#js.d.toString #js"utf8"))))
          (#js.console.log #js.params)
          (define tok (#js.params.get #js"access_token"))
          (#js.console.log ($/binop + #js"Received GH access_token: " tok))
          (#js.console.log ($/binop + #js"user id: " #js.req.session.id))
          (#js.console.log ($/binop + #js"stored access_token (before): " #js.req.session.access_token))
          ($/:= #js.req.session.access_token tok)
          (#js.console.log ($/binop + #js"stored access_token: " #js.req.session.access_token))
          (#js.req.session.save (λ (e) (#js.console.log #js"access_token saved")))
          (#js.console.log #js.req.session)
          ;; TODO: Is there a better way to do this?
          ;; send message to main window, to reflect logged in status; close gh login window
          (#js.res.send #js"<script>window.opener.postMessage('logged-in', window.location.origin);window.close()</script>")
#;          (set! ACCESS-TOKEN tok))))))
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

  (#js.app.get #js"/isloggedin" query-login)
  
  (#js.app.post #js"/compile" handle-compile)
  
  (#js.app.post #js"/save" handle-save)

  (#js.app.listen PORT
      (λ ()
        (#js.console.log #js"Starting playground at port" PORT)))

  (void))

(main)

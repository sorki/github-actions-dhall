-- types for events that trigger workflows (on:)
let Push =
      { Type =
          { branches : Optional (List Text)
          , branches-ignore : Optional (List Text)
          , tags : Optional (List Text)
          , tags-ignore : Optional (List Text)
          , paths : Optional (List Text)
          , paths-ignore : Optional (List Text)
          }
      , default =
        { branches = None (List Text)
        , branches-ignore = None (List Text)
        , tags = None (List Text)
        , tags-ignore = None (List Text)
        , paths = None (List Text)
        , paths-ignore = None (List Text)
        }
      }

let PullRequest =
      { Type =
          { branches : Optional (List Text)
          , branches-ignore : Optional (List Text)
          , paths : Optional (List Text)
          , paths-ignore : Optional (List Text)
          }
      , default =
        { branches = None (List Text)
        , branches-ignore = None (List Text)
        , paths = None (List Text)
        , paths-ignore = None (List Text)
        }
      }

let Cron = { Type = { cron : Text }, default.cron = "4 20 10 * *" }

let Event =
      { Type =
          { push : Optional Push.Type
          , pull_request : Optional PullRequest.Type
          , pull_request_target : Optional PullRequest.Type
          , schedule : Optional (List Cron.Type)
          }
      , default =
        { push = Some Push.default
        , pull_request = None PullRequest.Type
        , pull_request_target = None PullRequest.Type
        , schedule = Some [ Cron.default ]
        }
      }

in  { Push, PullRequest, Cron, Event }

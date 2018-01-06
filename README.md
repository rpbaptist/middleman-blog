# richardbaptist.nl
Personal blog site built with Middleman. I mostly did this because I wanted to figure out Middleman.

## Download

`git clone git@github.com:rpbaptist/richardbaptist.nl.git`

## Run locally
`bundle exec middleman s` 

## Build site
`rake build` 

## Build and deploy

First configure ENV variables in `Rakefile`.

Add the github pages as a remote:

`git remote add github-io git@github.com:rpbaptist/rpbaptist.github.io.git`

Then publish:

`rake publish` 
